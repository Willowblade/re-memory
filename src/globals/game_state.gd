extends Node

var game_state = {}

signal updated_game_state(game_state)


func _ready():
	AudioEngine.set_master_volume(0.6)
