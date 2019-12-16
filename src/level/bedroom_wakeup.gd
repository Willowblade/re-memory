extends Bedroom
class_name BedroomWakeup

onready var awake = $Background/Awake
onready var asleep = $Background/Asleep

func _ready():
	player.set_physics_process(false)
	awake.hide()


func set_awake():
	awake.show()
	asleep.hide()
