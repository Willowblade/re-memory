extends AudioStreamPlayer


var currently_playing = null


func _ready():
	pass
	

func is_available():
	return currently_playing == null
	

func play_sound(track_path: String, loop: bool = true):
	# TODO might not be always desired...
	if track_path == null or track_path == "":
		return
	var sound_audio_stream = load(track_path)
	sound_audio_stream.loop = loop
	stream = sound_audio_stream
	currently_playing = track_path
	play()
	

func finish():
	currently_playing = null
	# TODO maybe clear audio track?


