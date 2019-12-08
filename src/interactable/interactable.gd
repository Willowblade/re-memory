extends Area2D
class_name Interactable

export var enabled_at_start: bool = true

var enabled = enabled_at_start

var shapes = []

onready var tooltip = $Tooltip


signal interacted


func _ready():
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			shapes.append(child)
	if enabled:
		enable()
	else:
		disable()

func toggle_active():
	pass
	
func toggle_inactive():
	pass

func enable():
	enabled = true
	for shape in shapes:
		shape.disabled = false

func disable():
	enabled = false
	for shape in shapes:
		shape.disabled = true
		
func activate():
	if enabled:
		tooltip.show()
		toggle_active()
		
func deactivate():
	if enabled:
		tooltip.hide()
		toggle_inactive()
		
func interact():
	if enabled:
		print("Interacted!")
		emit_signal("interacted", self)
	else:
		print("Used interact on disabled interactable")

	