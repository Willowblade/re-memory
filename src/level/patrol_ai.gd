extends AI
class_name AIRandomPatrol

const type = "RANDOM_PATROL"


onready var timer = $Timer

var _start_position: Vector2
var _destination: Vector2

# TODO: State machine...
var in_progress: bool = false
var on_cooldown: bool = false
var can_start: bool = false
var started: bool = false

var directions = [Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)]
var current_direction: Vector2


func set_character(character):
	.set_character(character)
	_start_position = character.position
	
func _is_in_bounds(position: Vector2):
	var corners = {
		"top_left": _start_position - Vector2(_parameters.width * 32 / 2, _parameters.height * 32 / 2),
		"bottom_right": _start_position + Vector2(_parameters.width * 32 / 2, _parameters.height * 32 / 2),
	}
	
	return position.x < corners.bottom_right.x and position.x > corners.top_left.x and position.y < corners.bottom_right.y and position.y > corners.top_left.y

func _ready():
	for i in range(directions.size()):
		directions[i] *= 32

func random_direction() -> Vector2:
	var possible_directions = []
	for direction in directions:
		if direction != current_direction:
			possible_directions.append(direction)
	return possible_directions[randi() % possible_directions.size()]
	
func deactivate_interactions():
	for child in _character.get_children():
		if child is Interactable:
			child.disable()
			
func activate_interactions():
	for child in _character.get_children():
		if child is Interactable:
			child.enable()

func start_patrol():
	if on_cooldown:
		return
	if not in_progress:
		started = true
		can_start = false
		current_direction = random_direction()
			
		_character.set_orientation(current_direction)
		_character.update_animation(current_direction)
		
		timer.start(1.0)
		yield(timer, "timeout")

		
		set_physics_process(true)
		deactivate_interactions()
		
		can_start = true
		started = false

func end_patrol():
	on_cooldown = true
	
	timer.start(_parameters.idle_time + randf() * _parameters.idle_time_variation)
	yield(timer, "timeout")
	
	on_cooldown = false
	start_patrol()

func _physics_process(delta: float):
	if not self:
		return
	if not in_progress and not can_start and not started:
		start_patrol()
		set_physics_process(false)
		activate_interactions()
	if can_start:
		can_start = false
		if _is_in_bounds(_character.position + current_direction) and not _character.raycast.is_colliding():
			in_progress = true
			_destination = _character.position + current_direction
		else:
			set_physics_process(false)
			activate_interactions()
			start_patrol()
			
	if in_progress:
		var velocity = current_direction.normalized() * _parameters.speed * delta
		_character.update_animation(velocity)
		_character.move_and_collide(velocity)
		
		var angle_to_destination = int(rad2deg((_destination - _character.position).angle_to(current_direction)))
		# when past the objective
		if abs(angle_to_destination) > 90:
			_character.position = _destination
			in_progress = false
			set_physics_process(false)
			activate_interactions()
			end_patrol()
		

