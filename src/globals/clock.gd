extends Node


var now: float

var seconds_per_hour: float = 15

func _ready():
	set_process(false)
	

func reset():
	now = 0
	
func start():
	now = 0
	set_process(true)
	
func pause():
	set_process(false)
	
func stop():
	set_process(false)

func _process(delta: float):
	now += delta
	
func get_time():
	return {
		"hours": int(now / seconds_per_hour),
		"minutes": int(60 * fmod(now, seconds_per_hour) / seconds_per_hour),
	}
