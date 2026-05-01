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

func is_letter(character: String) -> bool:
	if len(character) != 1: return false

	var character_code = ord(character)
	if (character_code >= 65 and character_code <= 90) or (character_code >= 97 and character_code <= 122):
		return true
	else:
		return false