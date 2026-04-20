class_name SignalMonitor extends Control

@export var letter_backgrounds_container: HBoxContainer
var letter_backgrounds: Dictionary[String, Label]

@export var letter_indicators_container: HBoxContainer
var letter_indicators: Dictionary[String, Label]

@export var alert: Label
var alert_timer: float

var message: IncomingMessage

signal on_finished_decoding()

# Called when the node enters the scene tree for the first time.
func _ready():
	for letter_background: Label in letter_backgrounds_container.get_children():
		letter_backgrounds[letter_background.text.to_lower()] = letter_background
	for letter_indicator: Label in letter_indicators_container.get_children():
		letter_indicators[letter_indicator.text.to_lower()] = letter_indicator

	hide_letters()
	clear_alert()

	InputTracker.on_character_typed.connect(input_letter)


func hide_letters():
	letter_backgrounds_container.hide()
	letter_indicators_container.hide()
	clear_letters()
func show_letters():
	letter_backgrounds_container.show()
	letter_indicators_container.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alert_timer > 0:
		alert_timer -= delta
		if alert_timer <= 0 and message:
			alert_timer = 0
			update_signal_strength()



func init_message(p_message: IncomingMessage):
	message = p_message
	update_letters(message.get_guess_letter_frequencies())
	update_alert("New signal acquired.")
	alert_timer = 2.0


func update_letters(frequency_table: Dictionary[String, float]):
	for character in letter_indicators:
		letter_indicators[character].self_modulate.a = frequency_table.get(character, 0)

func clear_letters():
	for character in letter_indicators:
		letter_indicators[character].self_modulate.a = 0


func update_alert(new_alert: String, silent := true, pitch := 1.0):
	alert.text = new_alert
	if not silent: AudioManager.play_sound(
		AudioManager.TERMINAL_UPDATE, "SoundEffects", 1.0, PROCESS_MODE_ALWAYS, pitch
	)

func update_signal_strength():
	if not message: return
	update_alert("Signal strength: " + str(roundi(message.guess_ratio*100)) + "%")

func clear_alert():
	update_alert("")


func input_letter(character: String):
	if not message: return

	message.guess(character)
	if message.completed:
		message = null
		update_alert("Signal acquired. Awaiting response.")
		on_finished_decoding.emit()
		AudioManager.play_sound(AudioManager.FINISHED_DECODING)
		clear_letters()
	else:
		update_letters(message.get_guess_letter_frequencies())
		if not alert_timer: update_signal_strength()
