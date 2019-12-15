extends StaticBody2D
class_name Gate

onready var opened_sprite = $Opened
onready var closed_sprite = $Closed
onready var collision = $GateCollision

export var required_states = []

func _ready():
	pass

func update():
	if PlayerState.valid_conditions(required_states):
		opened_sprite.show()
		closed_sprite.hide()
		collision.disabled = true
	else:
		opened_sprite.hide()
		closed_sprite.show()
		collision.disabled = false
