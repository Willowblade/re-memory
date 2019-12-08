extends "res://src/level/ai/resource/AIParameters.gd"
class_name AIRandomPatrolParameters

const type = "RANDOM_PATROL"

export var speed = 30
export var width: int = 5
export var height: int = 5
export var idle_time: float = 0.5
export var idle_time_variation = 0.5
export var double_step_chance = 0.1


func _ready():
	pass
