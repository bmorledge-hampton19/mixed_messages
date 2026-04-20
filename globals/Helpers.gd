extends Node


const LETTERS: Array[String] = [
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
]

func get_random_letter(upper := false, exclude := '') -> String:
	var letter: String = LETTERS.pick_random()
	if upper: letter = letter.to_upper()

	if letter == exclude: return get_random_letter(upper, exclude)
	else: return letter

func is_whitespace(character: String) -> bool:
	assert(character.length() == 1, "is_whitespace() passed multiple characters but expected one.")
	return character in [' ', '\n', '\r', '\f', '\t', '\v']