extends Node2D


onready var hour_dial = $HourDial
onready var minute_dial = $MinuteDial


func _ready():
	pass
	
func _process(true):
	var time = Clock.get_time()
	
	hour_dial.rotation_degrees = time.hours * 5 * 6 - 90 + 30 * time.minutes / 60  # 12 hours per cycle
	minute_dial.rotation_degrees = time.minutes * 6  # 60 minutes per cycle
