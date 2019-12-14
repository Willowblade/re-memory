extends Interactable
class_name DialogueInteraction


export(String) var animation
export(String, FILE, "*.json") var dialogue_path

func _ready():
	if dialogue_path == null or dialogue_path == "":
		Logger.error("Dialogue " + name + " has no dialogue path given...")
