extends Interactable
class_name LeverInteraction

onready var active_sprite = $Active
onready var inactive_sprite = $Inactive


export var active: bool = false
export(String) var state = "lever"

func _ready():
	update_active()

func update_active():
	if active:
		PlayerState.add_state_to_player_states(state)
		active_sprite.show()
		inactive_sprite.hide()
	else:
		PlayerState.add_state_to_player_states("!" + state)
		active_sprite.hide()
		inactive_sprite.show()
		
func toggle():
	active = !active
	update_active()
