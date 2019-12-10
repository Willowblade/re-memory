extends KinematicBody2D
class_name Character


onready var animation = $Animation
onready var raycast = $RayCast

var orientation = Vector2(1, 0)

var orientation_memory = 0

func _ready():
	pass

func update_animation(speed: Vector2):
	print(speed)
	if speed == Vector2(0, 0):
		set_idle_animation()
	else:
		# makes it more achievable to maintain a diagonal direction after releasing the buttons and missing a frame
		if speed.normalized() != orientation:
			if orientation_memory == 1:
				set_orientation(speed.normalized())
				orientation_memory = 0
			else:
				orientation_memory += 1
		
#		orientation = speed.normalized()
		set_walk_animation()
		
func set_orientation(new_orientation: Vector2):
	orientation = new_orientation
	var direction = get_direction()
	
	if direction == "right":
		raycast.cast_to = Vector2(32, 0)
#		raycast.rotation_degrees = 0.0
	elif direction == "up_rigt":
		raycast.cast_to = Vector2(32, -32)
#		raycast.rotation_degrees = -45
	elif direction == "up":
		raycast.cast_to = Vector2(0, -32)
#		raycast.rotation_degrees = -90
	elif direction == "up_left":
		raycast.cast_to = Vector2(-32, -32)
#		raycast.rotation_degrees = -135
	elif direction == "left":
		raycast.cast_to = Vector2(-32, 0)
#		raycast.rotation_degrees = -180
	elif direction == "down_left":
		raycast.cast_to = Vector2(-32, 32)
#		raycast.rotation_degrees = -225
	elif direction == "down":
		raycast.cast_to = Vector2(0, 32)
#		raycast.rotation_degrees = -270
	elif direction == "down_right":
		raycast.cast_to = Vector2(32, 32)
#		raycast.rotation_degrees = -315
		

func _set_directional_animation(animation_name: String):
	var directional_animation_name = animation_name + "_" + get_direction()
	if not directional_animation_name in animation.frames.get_animation_names():
		print("Animation " + animation_name + "does not exist for " + name)
	_set_animation(directional_animation_name)
	
func _set_animation(animation_name: String):
	if animation.animation != animation_name:
		animation.animation = animation_name

func set_idle_animation():
	print("Setting idle animation")
	_set_directional_animation("idle")
	
func set_walk_animation():
	print("Setting walk animation")
	_set_directional_animation("walk")
	
func get_direction():
	if orientation.x > sqrt(3)/2:
		return "right"
	elif orientation.x < -sqrt(3)/2:
		return "left"
	elif orientation.y > sqrt(3)/2:
		return "down"
	elif orientation.y < -sqrt(3)/2:
		return "up"
	elif orientation.x > 0 and orientation.y > 0:
		return "down_right"
	elif orientation.x > 0 and orientation.y < 0:
		return "up_right"
	elif orientation.x < 0 and orientation.y > 0:
		return "down_left"
	elif orientation.x < 0 and orientation.y < 0:
		return "up_left"
