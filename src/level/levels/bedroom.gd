extends Level



func _ready():
	var all_items = true
	for item in items:
		if item == "treasure_box":
			continue
		if not item in PlayerState.unlocked_furniture:
			all_items = false
			
	if all_items:
		$Transitions/RegularTransition.disable()
	else:
		$Transitions/EmptyRoomTransition.disable()


# overrides function of Level, causing custom item code.
func prepare_furniture():
	for item in items:
		if item in PlayerState.unlocked_furniture:
			items[item].set_complete()
		else:
			items[item].set_incomplete()

