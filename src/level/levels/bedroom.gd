extends Level


onready var items = {
	"bookcase": $Objects/Bookcase,
	"carpet": $Objects/Carpet,
	"basket": $Objects/Basket,
	"tables": $Objects/Tables,
	"tv": $Objects/TV,
	"dresser": $Objects/Dresser,
	"treasure_box": $Objects/TreasureBox,
}


func _ready():
	for item in items:
		if item in PlayerState.unlocked_furniture:
			items[item].set_complete()
		else:
			items[item].set_incomplete()
