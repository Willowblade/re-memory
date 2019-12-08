"""
Audio Engine

Implemented:
	- Background music
	- Sound effects
	- Sounds for objects that generally make sounds

To implement:
	- Speech for conversations
"""
extends Node


onready var background_player: AudioStreamPlayer = get_node("BackgroundPlayer")
onready var speech_player: AudioStreamPlayer = get_node("SpeechPlayer")
onready var effects: Node = get_node("Effects")
onready var sounds: Node = get_node("Sounds")


export var master_volume := 1.0 setget set_master_volume
export var effects_volume := 1.0 setget set_effects_volume
export var sounds_volume := 1.0 setget set_sounds_volume
export var background_volume := 1.0 setget set_background_volume


func convert_scale_to_db(scale: float):
	return 20 * log(scale) / log(10)

func set_master_volume(new_master_volume: float):
	print("Setting the master volume to ", new_master_volume)
	master_volume = new_master_volume
	set_effects_volume(effects_volume)
	set_sounds_volume(sounds_volume)
	set_background_volume(background_volume)

func set_effects_volume(new_effects_volume: float):
	effects_volume = new_effects_volume
	for effect_player in effects.effect_players:
		effect_player.volume_db = convert_scale_to_db(master_volume * effects_volume)

func set_sounds_volume(new_sounds_volume: float):
	sounds_volume = new_sounds_volume
	for sound_player in sounds.sound_players:
		sound_player.volume_db = convert_scale_to_db(master_volume * sounds_volume)



func set_background_volume(new_background_volume: float):
	background_volume = new_background_volume
	background_player.volume_db = convert_scale_to_db(master_volume * background_volume)


var background_audio = null

export var MAX_SIMULTANEOUS_EFFECTS = 5
export var MAX_SIMULTANEOUS_SOUNDS = 5


func _ready():
	#play_background_music("light_rain")
	for _i in range(MAX_SIMULTANEOUS_EFFECTS):
		effects.add_effect()
	for _i in range(MAX_SIMULTANEOUS_SOUNDS):
		sounds.add_sound()

func play_speech(track_path: String):
	speech_player.play_speech(track_path)

func play_effect(track_path: String):
	play_positioned_effect(track_path, get_viewport().get_visible_rect().size / 2)

func play_positioned_effect(track_path: String, position: Vector2 = Vector2(0, 0)):
	effects.play_effect(track_path, position)

# TODO: keep a number of AudioStreamPlayer2D and regular AudioStreamPlayer in sounds and effects
#  because now the audio won't move with the viewport if the viewport moves which you want with normal sounds and effects
func play_sound(track_path: String, loop: bool = true):
	sounds.play_sound(track_path, loop)

func play_positioned_sound(track_path: String, loop: bool = true):
	sounds.play_sound(track_path, loop)
# TODO merge these in sounds etc
func pause_sound(track_path: String) -> bool:
	return sounds.pause_sound(track_path)

func unpause_sound(track_path: String):
	return sounds.unpause_sound(track_path)
	
func stop_sound(track_path: String):
	for sound in sounds.sound_players:
		if sound.currently_playing == track_path:
			sound.stop()
			sound.loop = false
			sound.audio_stream = null
			
func reset():
	sounds.reset()
#	effects.reset()
	background_player.stop()
	speech_player.stop()

func play_background_music(track_path: String):
	"""Initiates a track to play as background music"""
	if background_audio != track_path:
		background_player.stream = load(track_path)
		background_player.play()

func stop_background_music():
	"""Stops the background music track"""
	if background_player.playing:
		background_player.stream()
		background_audio = null


