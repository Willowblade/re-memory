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
	for child in get_children():
		if child is Interactable:
			child.connect("interacted", self, "_on_interaction_interacted")
		
func generate_ai():
	if ai_parameters:
		return ai_scenes.get(ai_parameters.type).instance()
	else:
		return ai_scenes.IDLE.instance()

func turn_towards(coordinates: Vector2):
	set_orientation(position - coordinates)

func _on_interaction_interacted():
	turn_towards(get_node("../..").player.position)
