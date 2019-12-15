extends StaticBody2D
class_name Gate

onready var opened_sprite = $Opened
onready var closed_sprite = $Closed
onready var collision_closed = $GateCollisionActive
onready var collision_open = [$GateCollisionOpen1, $GateCollisionOpen2]

export var required_states = []

func _ready():
	pass

func update():
	if PlayerState.valid_conditions(required_states):
		opened_sprite.show()
		closed_sprite.hide()
		collision_closed.disabled = true
		for collision in collision_open:
			collision.disabled = false
	else:
		opened_sprite.hide()
		closed_sprite.show()
		collision_closed.disabled = false
		for collision in collision_open:
			collision.disabled = true
