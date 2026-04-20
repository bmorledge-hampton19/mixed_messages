class_name OutgoingMessage extends Node

@export var message_label: Label
var message: String:
	get(): return message_label.text
	set(value): message_label.text = value
const TYPING_SPEED = 30.0

signal on_finished_typing(wait_for_response: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	message_label.visible_ratio = 0


func _process(delta):
	if message_label.visible_ratio < 1:
		message_label.visible_ratio += 1.0/float(message.length())*TYPING_SPEED*delta
		if message_label.visible_ratio >= 1:
			message_label.visible_ratio = 1
			AudioManager.keyboard_clacking_player.stop()
			if message.ends_with('-'): on_finished_typing.emit(false)
			else: on_finished_typing.emit(true)


func init(p_message: String):
	message = p_message
	message_label.visible_ratio = 0
	AudioManager.keyboard_clacking_player.play()