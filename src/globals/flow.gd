extends Node

onready var menu = preload("res://src/menus/MainMenu.tscn")
onready var game = preload("res://src/game/Game.tscn")


func _ready():
	pass
	
func go_to_game():
	AudioEngine.reset()
	get_tree().change_scene_to(game)
	
func go_to_main_menu():
	AudioEngine.reset()
	get_tree().change_scene_to(menu)
	
func pause():
	yield(get_tree().create_timer(0.0), "timeout")
	get_tree().paused = true

func resume():
	# this makes sure that the player's inputs aren't immediately processed, otherwise infinite loop for dialogue and textbox
	yield(get_tree().create_timer(0.0), "timeout")
	get_tree().paused = false
	
func quit():
	get_tree().quit()
