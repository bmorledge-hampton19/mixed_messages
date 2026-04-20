extends Node

signal on_character_typed(character: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	# on_character_typed.connect(test)
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent):

	var key_event := event as InputEventKey

	if key_event and key_event.pressed and not key_event.is_echo():

		var key_code := key_event.unicode
		if (key_code >= 65 and key_code <= 90) or (key_code >= 97 and key_code <= 122):
			on_character_typed.emit(char(key_event.unicode).to_lower())

func test(character: String):
	print(character)