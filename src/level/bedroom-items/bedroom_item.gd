extends StaticBody2D

onready var sprite = $Sprite
onready var active_interaction = $ActiveInteraction
onready var inactive_interaction = $InactiveInteraction

func _ready():
	pass
	
func set_incomplete():
	active_interaction.disable()
	inactive_interaction.enable()
	sprite.modulate = Color("#4d2ed820")
	
func set_complete():
	active_interaction.enable()
	inactive_interaction.disable()
	sprite.modulate = Color("#ffffffff")
