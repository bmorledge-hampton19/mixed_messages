class_name OneShotAudio extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(p_stream: AudioStream, bus_name: String = "SoundEffects", p_volume_linear: float = 1, p_pitch_scale: float = 1):
	stream = p_stream
	bus = bus_name
	volume_linear = p_volume_linear
	pitch_scale = p_pitch_scale
	finished.connect(self_destruct)
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func self_destruct():
	queue_free()