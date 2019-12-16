extends Level
class_name Hospital

onready var interaction = $Interactions/TextInteraction

onready var awake = $Background/Awake
onready var asleep = $Background/Asleep

func _ready():
	player.set_physics_process(false)
	awake.hide()


func set_awake():
	awake.show()
	asleep.hide()

func set_asleep():
	awake.hide()
	asleep.show()
