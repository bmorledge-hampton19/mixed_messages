class_name GuessingLetter extends Label

@export var initialize_self := false

var guessed: bool
var correct_character: String
var is_upper: bool:
	get(): return (
		correct_character == correct_character.to_upper() and
		correct_character != correct_character.to_lower()
	)

var index: int

const AVG_CHANGE_COUNTDOWN := 1.0
const CHANGE_COUNTDOWN_VAR := 0.4
var change_countdown: float
var changes_since_correct: int

const CORRECT_COLOR = Color.BLACK
const GUESSING_COLOR = Color.DIM_GRAY

signal on_click(guessing_letter: GuessingLetter)


# Called when the node enters the scene tree for the first time.
func _ready():
	if initialize_self:
		var color = self_modulate
		init(text, true)
		self_modulate = color

func init(p_correct_character: String, requires_guess: bool, p_index: int = -1):
	correct_character = p_correct_character
	index = p_index
	if requires_guess:
		change()
		changes_since_correct = randi_range(-2,2)
		self_modulate = GUESSING_COLOR
	else:
		guess(correct_character)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not guessed:
		change_countdown -= delta
		if change_countdown <= 0:
			change()
			reset_change_countdown()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		on_click.emit(self)



func reset_change_countdown():
	change_countdown = AVG_CHANGE_COUNTDOWN + randf_range(-CHANGE_COUNTDOWN_VAR, CHANGE_COUNTDOWN_VAR)

func change():
	if randf() < changes_since_correct*0.2:
		changes_since_correct = 0
		text = correct_character
	else:
		changes_since_correct += 1
		text = Help.get_random_letter(is_upper, correct_character)


func guess(character: String) -> bool:
	if character.to_lower() == correct_character.to_lower():
		text = correct_character
		self_modulate = CORRECT_COLOR
		guessed = true

	return guessed
