extends Node2D


export var start_time = {
	"hours": 6,
	"minutes": 0
}

var seconds_per_hour: float = 15
export var end_time: Dictionary = {
	"hours": 12,
	"minutes": 0
}

onready var hour_dial = $HourDial
onready var minute_dial = $MinuteDial

signal finished

func _ready():
	pass
	
func set_time(time: Dictionary):
	hour_dial.rotation_degrees = time.hours * 5 * 6 - 90 + 30 * time.minutes / 60  # 12 hours per cycle
	minute_dial.rotation_degrees = time.minutes * 6  # 60 minutes per cycle
	if time.hours >= end_time.hours and time.minutes >= end_time.minutes:
		emit_signal("finished") 
	
func make_time(seconds: float) -> Dictionary :
	var time_offset = start_time.hours * seconds_per_hour + seconds_per_hour * start_time.minutes / 60
	var total_time = seconds + time_offset
	
	return {
		"hours": int(total_time / seconds_per_hour),
		"minutes": int(60 * fmod(total_time, seconds_per_hour) / seconds_per_hour),
	}

func _process(true):
	var time = Clock.get_time()
	set_time(make_time(time))

