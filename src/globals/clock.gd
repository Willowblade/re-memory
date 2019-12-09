extends Node


var timer: float

func _ready():
	set_process(false)

func reset():
	timer = 0
	
func start():
	timer = 0
	set_process(true)
	
func pause():
	set_process(false)
	
func stop():
	set_process(false)

func _process(delta: float):
	timer += delta
	
func get_time():
	return timer
