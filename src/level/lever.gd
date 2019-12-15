extends Interactable
class_name LeverInteraction

onready var active_sprite = $Active
onready var inactive_sprite = $Inactive


export var active: bool = false
export var lever_name = "lever"
export var states: PoolStringArray = PoolStringArray(["lever"])

func _ready():
	active = active_in_states()
	update_active()
	
func active_in_states():
	return PlayerState.has_condition(lever_name + "-pulled")

func update_active():
	if active:
		if not active_in_states():
			for state in states:
				if PlayerState.has_condition(state):
					PlayerState.remove_state_from_player_states(state)
				else:
					PlayerState.add_state_to_player_states(state)
		active_sprite.show()
		inactive_sprite.hide()
	else:
		if active_in_states():
			for state in states:
				if PlayerState.has_condition(state):
					PlayerState.remove_state_from_player_states(state)
				else:
					PlayerState.add_state_to_player_states(state)
		active_sprite.hide()
		inactive_sprite.show()
		
func toggle():
	active = !active
	update_active()
	if active:
		PlayerState.add_state_to_player_states(lever_name + "-pulled")
	else:
		PlayerState.remove_state_from_player_states(lever_name + "-pulled")
