class_name Main extends Node2D

@export var story_tracker: StoryTracker
@export var signal_monitor: SignalMonitor
@export var chat_container: ScrollContainer
@export var message_container: VBoxContainer

@export var fade_to_black: ColorRect
@export var ending_graphic: CanvasGroup

var calibrating := true
var calibration_stage := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	signal_monitor.on_finished_decoding.connect(finish_incoming_message)
	play_intro_sequence()

	chat_container.get_v_scroll_bar().changed.connect(func():
		chat_container.scroll_vertical = int(
			chat_container.get_v_scroll_bar().max_value-chat_container.get_v_scroll_bar().size.y
		)
	)


func play_intro_sequence():
	var intro_tween := create_tween()

	intro_tween.tween_callback(AudioManager.ambiance_player.play)
	for i in 3:
		intro_tween.tween_callback(func(): signal_monitor.update_alert("Scanning for connection requests."))
		intro_tween.tween_interval(1)
		intro_tween.tween_callback(func(): signal_monitor.update_alert("Scanning for connection requests.."))
		intro_tween.tween_interval(1)
		intro_tween.tween_callback(func(): signal_monitor.update_alert("Scanning for connection requests..."))
		intro_tween.tween_interval(1)
	
	intro_tween.tween_callback(func(): signal_monitor.update_alert("New connection request received.", false, 1.5))
	intro_tween.tween_interval(4)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Attempting to establish connection.", false, 1.25))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Attempting to establish connection.."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Attempting to establish connection..."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Attempting to establish connection...."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Attempting to establish connection....."))

	intro_tween.tween_interval(0.5)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Connection established.", false, 1.5))
	intro_tween.tween_interval(2.0)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Warning: connection is unstable.", false, 1.0))
	intro_tween.tween_interval(3.0)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Incoming signals will require manual tuning.",false,1.25))
	intro_tween.tween_interval(3.0)

	intro_tween.tween_callback(func(): signal_monitor.update_alert("Booting up signal monitor.", false, 1.25))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Booting up signal monitor.."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Booting up signal monitor..."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Booting up signal monitor...."))
	intro_tween.tween_interval(0.5)
	
	intro_tween.tween_callback(signal_monitor.show_letters)
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Signal monitor operational.",false,1.5))
	intro_tween.tween_interval(3)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Initializing user calibration.", false, 1.25))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Initializing user calibration.."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(func(): signal_monitor.update_alert("Initializing user calibration..."))
	intro_tween.tween_interval(1)
	intro_tween.tween_callback(get_calibration_message)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if calibrating and signal_monitor.message:
		if calibration_stage < 1 and signal_monitor.message.guess_ratio > 0:
			signal_monitor.alert_timer = 60
			calibration_stage = 1
			signal_monitor.update_alert("Begin calibration. Keyboard mashing recommended.")
		elif calibration_stage < 2 and signal_monitor.message.guess_ratio > 0.3:
			signal_monitor.alert_timer = 60
			calibration_stage = 2
			signal_monitor.update_alert("Use signal monitor to determine upcoming keys.", false, 1.25)
		elif calibration_stage < 3 and signal_monitor.message.guess_ratio > 0.6:
			signal_monitor.alert_timer = 60
			calibration_stage = 3
			signal_monitor.update_alert("Fully decode message to complete calibration.", false, 1.25)
		elif calibration_stage < 4 and signal_monitor.message.guess_ratio > 0.8:
			signal_monitor.alert_timer = 0
			calibration_stage = 4
			signal_monitor.update_signal_strength()


func get_calibration_message():
	calibrating = true
	var calibration_message := story_tracker.get_calibration_message()
	message_container.add_child(calibration_message)
	signal_monitor.init_message(calibration_message, false)
	AudioManager.play_sound(AudioManager.NEW_MESSAGE)


func get_next_message():
	var next_message = story_tracker.get_next_message()

	if not next_message: play_ending_sequence(); return

	message_container.add_child(next_message)
	if next_message is IncomingMessage:
		signal_monitor.init_message(next_message)
		AudioManager.play_sound(AudioManager.NEW_MESSAGE)
	elif next_message is OutgoingMessage:
		(next_message as OutgoingMessage).on_finished_typing.connect(finish_outgoing_message)


func finish_incoming_message():
	var finish_message_tween := create_tween()

	if calibrating:

		finish_message_tween.tween_callback(func(): signal_monitor.update_alert("Calibration complete. Receiving message..."))
		finish_message_tween.tween_interval(3)
		finish_message_tween.tween_callback(get_next_message)
		finish_message_tween.tween_interval(5)
		finish_message_tween.tween_callback(AudioManager.music_player.play)

		calibrating = false

	else:
		finish_message_tween.tween_callback(func(): signal_monitor.update_alert("Signal locked. Ready to transmit response."))
		finish_message_tween.tween_interval(2)

		finish_message_tween.tween_callback(get_next_message)

func finish_outgoing_message(wait_for_response := true):
	var finish_message_tween := create_tween()

	finish_message_tween.tween_callback(func(): signal_monitor.update_alert("Message delivered. Awaiting response..."))
	if wait_for_response: finish_message_tween.tween_interval(randf_range(4,6))

	finish_message_tween.tween_callback(get_next_message)


func play_ending_sequence():
	var ending_tween := create_tween()

	ending_tween.tween_interval(2)
	ending_tween.tween_callback(func(): AudioManager.fade_out_music(4))
	ending_tween.tween_property(fade_to_black,"modulate",Color.WHITE, 4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	ending_tween.tween_interval(2)
	ending_tween.tween_property(ending_graphic,"modulate",Color.WHITE, 4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
