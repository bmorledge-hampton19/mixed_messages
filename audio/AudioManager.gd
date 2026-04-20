extends Node

@export var sound_effects_node: Node2D
@export var one_shot_audio_prefab: PackedScene

@export var music_player: AudioStreamPlayer2D
@export var ambiance_player: AudioStreamPlayer2D
@export var keyboard_clacking_player: AudioStreamPlayer2D

const SOUND_EFFECTS_DIR = "res://audio/sound_effects/"

const TERMINAL_UPDATE = preload(SOUND_EFFECTS_DIR + "terminal_update.wav")
const NEW_MESSAGE = preload(SOUND_EFFECTS_DIR + "new_message.wav")
const WRONG_LETTER_1 = preload(SOUND_EFFECTS_DIR + "wrong_letter_1.wav")
const WRONG_LETTER_2 = preload(SOUND_EFFECTS_DIR + "wrong_letter_2.wav")
const WRONG_LETTER_3 = preload(SOUND_EFFECTS_DIR + "wrong_letter_3.wav")
const WRONG_LETTERS: Array[AudioStream] = [WRONG_LETTER_1, WRONG_LETTER_2, WRONG_LETTER_3]
const RIGHT_LETTER_1 = preload(SOUND_EFFECTS_DIR + "right_letter_1.wav")
const RIGHT_LETTER_2 = preload(SOUND_EFFECTS_DIR + "right_letter_2.wav")
const RIGHT_LETTER_3 = preload(SOUND_EFFECTS_DIR + "right_letter_3.wav")
const RIGHT_LETTER_4 = preload(SOUND_EFFECTS_DIR + "right_letter_4.wav")
const RIGHT_LETTER_5 = preload(SOUND_EFFECTS_DIR + "right_letter_5.wav")
const RIGHT_LETTER_6 = preload(SOUND_EFFECTS_DIR + "right_letter_6.wav")
const RIGHT_LETTER_7 = preload(SOUND_EFFECTS_DIR + "right_letter_7.wav")
const RIGHT_LETTER_8 = preload(SOUND_EFFECTS_DIR + "right_letter_8.wav")
const RIGHT_LETTERS: Array[AudioStream] = [
	RIGHT_LETTER_1, RIGHT_LETTER_2, RIGHT_LETTER_3, RIGHT_LETTER_4,
	RIGHT_LETTER_5, RIGHT_LETTER_6, RIGHT_LETTER_7, RIGHT_LETTER_8
]
const FINISHED_DECODING = preload(SOUND_EFFECTS_DIR + "finished_decoding.wav")

var music_fade_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if Input.is_action_just_pressed("mute"):
		if AudioServer.get_bus_volume_linear(0): AudioServer.set_bus_volume_linear(0, 0)
		else: AudioServer.set_bus_volume_linear(0, 1)


func play_sound(
	stream: AudioStream, busName: String = "SoundEffects", volume_linear: float = 1,
	p_process_mode := PROCESS_MODE_ALWAYS, pitch_scale: float = 1
) -> OneShotAudio:
	var one_shot_audio: OneShotAudio = one_shot_audio_prefab.instantiate()
	one_shot_audio.process_mode = p_process_mode
	sound_effects_node.add_child(one_shot_audio)
	one_shot_audio.init(stream, busName, volume_linear, pitch_scale)
	return one_shot_audio

func clear_sounds(keep := []):
	for sound_effect in sound_effects_node.get_children():
		if sound_effect is OneShotAudio and sound_effect.stream not in keep:
			sound_effect.queue_free()


func play_wrong_letter() -> OneShotAudio:  
	return play_sound(WRONG_LETTERS.pick_random(), "SoundEffects", 1.25, PROCESS_MODE_ALWAYS, randf_range(0.8,1.25))
func play_right_letter() -> OneShotAudio:  
	return play_sound(RIGHT_LETTERS.pick_random(), "SoundEffects", 1, PROCESS_MODE_ALWAYS, 1.0)

func fade_out_music(duration := 2.0):
	if music_fade_tween and music_fade_tween.is_valid(): music_fade_tween.kill()
	music_fade_tween = create_tween()
	music_fade_tween.tween_property(music_player, "volume_linear", 0, duration)
	music_fade_tween.tween_callback(music_player.stop)