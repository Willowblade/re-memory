tool
extends Sprite

export(String, "interact") var type = "interact" setget set_type

var tooltips = {
	"interact": {
		"keyboard": Rect2(0, 0, 16, 16),
		"controller": Rect2(16, 0, 16, 16),
	},
}

var control_scheme = "keyboard"

func _ready():
	region_rect = tooltips[type][control_scheme]


func set_type(new_type):
	type = new_type
	region_rect = tooltips[type][control_scheme]

func update_control_scheme(new_control_scheme):
	control_scheme = new_control_scheme
	region_rect = tooltips[type][control_scheme]
