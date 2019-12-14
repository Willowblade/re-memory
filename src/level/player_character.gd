extends Character
class_name PlayerCharacter

export var movement_speed: float = 200.0


var current_interactable

signal interacted(interactable)

func _ready():
	pass
	

func _physics_process(delta):
	var velocity = Vector2(0, 0)
	var speed_factor = 1.0
	
	if Input.is_action_pressed("sprint"):
		speed_factor *= 2.0

	if Input.is_action_pressed("ui_left"):
		velocity.x -= movement_speed * speed_factor
		
	if Input.is_action_pressed("ui_right"):
		velocity.x += movement_speed * speed_factor
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += movement_speed * speed_factor
		
	if Input.is_action_pressed("ui_up"):
		velocity.y -= movement_speed * speed_factor

	
	if raycast.is_colliding():
		var interactable = raycast.get_collider()
		if current_interactable != interactable:
			if current_interactable:
				current_interactable.deactivate()
			current_interactable = interactable
			current_interactable.activate()
	else:
		if current_interactable:
			current_interactable.deactivate()
			current_interactable = null

	if Input.is_action_just_pressed("ui_accept"):
		print(current_interactable)
		if current_interactable:
			emit_signal("interacted", current_interactable)
#			current_interactable.interact()
		
	update_animation(velocity)
	
	# fixes sliding along when pressed against an NPC
	move_and_slide(velocity, orientation.normalized())
	
func interacting(interactable_path: String):
	emit_signal("interacted", get_node(interactable_path))
