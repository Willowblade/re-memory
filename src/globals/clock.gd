extends Node


var always_running_timer: float
var timer: float

var in_game_time_enabled: bool = false

func _ready():
	pass

func reset():
	timer = 0
	
func start():
	timer = 0
	
func pause():
	in_game_time_enabled = false
	
func stop():
	in_game_time_enabled = false

func _process(delta: float):
	always_running_timer += delta
	if in_game_time_enabled:
		timer += delta
	
func get_time():
	return timer
