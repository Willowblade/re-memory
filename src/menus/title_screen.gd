extends Node2D

const MOUSE_UTIL = preload("res://src/util/mouse_util.gd")


func _ready():
	pass
	

func _input(event):
	if MOUSE_UTIL.is_left_mouse_pressed(event):
		Flow.go_to_main_menu()
	if Input.is_action_just_pressed("ui_accept"):
		Flow.go_to_main_menu()
