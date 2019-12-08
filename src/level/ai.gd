extends Node
class_name AI

var _character
var _parameters

func _ready():
	pass

func set_character(character):
	_parameters = character.ai_parameters
	_character = character

	

