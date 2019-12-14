extends Level


func _ready():
	for item in items:
		if item in PlayerState.unlocked_furniture:
			items[item].set_complete()
		else:
			items[item].set_incomplete()
