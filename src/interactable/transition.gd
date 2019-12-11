extends Interactable
class_name Transition

export(String, FILE, "*.tscn") var destination_path: String
export var marker_tag: String = ""

var destination

func _ready():
	destination = load(destination_path)
	if marker_tag == "" or marker_tag == null:
		Logger.error("Transition has no target tag")
