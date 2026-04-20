class_name IncomingMessage extends Control

const LINE_LENGTH = 30

@export var caret: Control
var CARET_BLINK_RATE = 1.0
var caret_blink_countdown: float

@export var complete_message: Label
var message: String:
	get(): return complete_message.text
	set(value): complete_message.text = value
@export var missing_letter_rate := 0.5

@export var guessing_letters_container: GridContainer
@export var guessing_letter_prefab: PackedScene
var guessing_letters: Array[GuessingLetter]
var guessing_index: int
var current_guessing_letter: GuessingLetter:
	get(): return guessing_letters[guessing_index] if guessing_letters else null
var total_letters: int
var guess_ratio: float:
	get(): return 1.0-guessing_letters.size()/float(total_letters)

@export var falling_letters_node: Control
@export var falling_letter_prefab: PackedScene


var completed: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	complete_message.hide()


func init(p_message: String, p_missing_letter_rate := 0.5):
	message = p_message
	missing_letter_rate = p_missing_letter_rate
	var line_start_index := 0
	var line_end_index := 0

	while line_start_index < message.length():
		# Check for trailing whitespace.
		if message[line_end_index] != '\n':
			while message[line_start_index] == ' ':
				line_start_index += 1
				if line_start_index >= message.length(): return

		# Initialize the next line.
		var characters_this_line := 0
		line_end_index = get_next_line_end_index(line_start_index)
		for i in range(line_start_index, line_end_index+1):
			if message[i] == '\n':
				assert(i == line_end_index, "newline found before designated end of line.")
				continue
			
			init_guess_letter(message[i])
			characters_this_line += 1

		while characters_this_line < LINE_LENGTH:
			init_guess_letter(' ')
			characters_this_line += 1

		line_start_index = line_end_index + 1

# Returns the next character after which a line break is required.
func get_next_line_end_index(from_index: int) -> int:

	var current_index = from_index
	var last_valid_index = from_index - 1

	while current_index - from_index < LINE_LENGTH:
		if current_index + 1 >= message.length():
			last_valid_index = message.length()-1
			break
		elif message[current_index] == ' ':
			last_valid_index = current_index
		elif message[current_index + 1] == '\n':
			last_valid_index = current_index + 1
			break
		current_index += 1

	if last_valid_index == from_index - 1: last_valid_index = clampf(from_index + LINE_LENGTH - 1, 0, message.length()-1)

	return last_valid_index


func init_guess_letter(character := " "):
	var guessing_letter: GuessingLetter = guessing_letter_prefab.instantiate()
	if character.to_lower() in Help.LETTERS:
		total_letters += 1
		if randf() < missing_letter_rate or guessing_letters.size() == 0:
			guessing_letter.init(character, true)
			guessing_letters.append(guessing_letter)
		else:
			guessing_letter.init(character, false)
	else:
		guessing_letter.init(character, false)
	guessing_letters_container.add_child(guessing_letter)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not completed:
		caret_blink_countdown -= delta
		if caret_blink_countdown <= 0:
			# if caret.visible: caret.hide()
			# else: caret.show()
			caret_blink_countdown = CARET_BLINK_RATE

		if Input.is_action_just_pressed("left"):
			guessing_index = wrapi(guessing_index-1,0,guessing_letters.size())
			if current_guessing_letter: caret.global_position = current_guessing_letter.global_position
		if Input.is_action_just_pressed("right"):
			guessing_index = wrapi(guessing_index+1,0,guessing_letters.size())
			if current_guessing_letter: caret.global_position = current_guessing_letter.global_position

func guess(character: String):
	if current_guessing_letter.is_upper: character = character.to_upper()

	if current_guessing_letter.guess(character):
		guessing_letters.remove_at(guessing_index)
		if not guessing_letters: complete()
		else: AudioManager.play_right_letter()
	else:
		var falling_letter: FallingLetter = falling_letter_prefab.instantiate()
		falling_letters_node.add_child(falling_letter)
		falling_letter.text = character
		falling_letter.global_position = current_guessing_letter.global_position
		guessing_index += 1
		AudioManager.play_wrong_letter()

	if guessing_index >= guessing_letters.size(): guessing_index = 0
	if current_guessing_letter: caret.global_position = current_guessing_letter.global_position


const FREQUENCY_RADIUS = 5
func get_guess_letter_frequencies() -> Dictionary[String,float]:
	var max_count = 1
	var frequency_table: Dictionary[String,float]

	if guessing_letters.size() < FREQUENCY_RADIUS*2 + 1:
		for guessing_letter in guessing_letters:
			var character := guessing_letter.correct_character.to_lower()
			var count: int = frequency_table.get_or_add(character, 0) + 1
			frequency_table[character] = count
			if count > max_count: max_count = count
	else:
		for i in range(guessing_index - FREQUENCY_RADIUS, guessing_index + FREQUENCY_RADIUS + 1):
			var guessing_letter := guessing_letters[wrapi(i,0,guessing_letters.size())]
			var character := guessing_letter.correct_character.to_lower()
			var count: int = frequency_table.get_or_add(character, 0) + 1
			frequency_table[character] = count
			if count > max_count: max_count = count

	for character in frequency_table:
		frequency_table[character] /= max_count	

	return frequency_table


func complete():
	guessing_letters_container.queue_free()
	complete_message.show()
	completed = true
	caret.hide()
