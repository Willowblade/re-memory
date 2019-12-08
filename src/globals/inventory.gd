extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var max_size: int = 0

var inventory: Array = []

const ITEMS = {
	"potion": {
		"name": "potion",
		"max": 99,
	}
}

signal inventory_updated(inventory)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _add_item(new_item):
	for item in inventory:
		if item.name == new_item.name:
			if ITEMS[item.name].get("unique", false):
				print("Trying to re-add unique item")
				return false
			else:
				item.count = min(ITEMS[item.name].get("max", 99), item.count + new_item.count)
				return true
	if max_size != 0 and len(inventory) == max_size:
		print("inventory full")
		return false
		inventory.append(new_item)
	return true

func add_item(new_item):
	_add_item(new_item)

	emit_signal("inventory_updated", inventory)

func add_items(new_items: Array):
	for new_item in new_items:
		_add_item(new_item)

	emit_signal("inventory_updated", inventory)
				# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func has_item(item_to_check):
	for item in inventory:
		if item_to_check.name == item.name:
			return true
	return false