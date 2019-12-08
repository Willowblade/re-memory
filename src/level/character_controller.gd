extends Character
class_name CharacterController


export var ai_parameters: Resource


onready var ai_scenes = {
	"RANDOM_PATROL": preload("res://src/level/AIRandomPatrol.tscn"),
	"IDLE": preload("res://src/level/AIRandomPatrol.tscn")
}

var character: Character

var action: Dictionary

func _ready():
	pass
		
func generate_ai():
	if ai_parameters:
		return ai_scenes.get(ai_parameters.type).instance()
	else:
		return ai_scenes.IDLE.instance()

