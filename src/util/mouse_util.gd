# mostly meant to abstract mouse event logic
# also kinda for making Godot 3 migration easier

static func is_left_mouse_pressed(event):
	return event is InputEventMouseButton && event.button_index == 1 && event.is_pressed()

static func is_mouse_move(event):
	return event is InputEventMouseMotion

static func is_right_mouse_pressed(event):
	return event is InputEventMouseButton && event.button_index == 2 && event.is_pressed()
	
static func fake_mouse_move_event(local_mouse_position: Vector2, global_mouse_position: Vector2, movement=Vector2(0, 0)):
	var mouse_event = InputEventMouseMotion.new()
	mouse_event.position = local_mouse_position
	mouse_event.relative = movement
	mouse_event.global_position = global_mouse_position
	Input.parse_input_event(mouse_event)