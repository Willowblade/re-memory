extends Node2D


onready var levels = {
	"test": preload("res://src/level/levels/TestLevelBase.tscn")
}

var level: Level

func _ready():
	_load_level(levels.test)

func reset_contents():
	if level != null:
		level.queue_free()
		level = null
	
func _load_level(new_level_scene: PackedScene):
	if level != null:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
	reset_contents()
	level = new_level_scene.instance()
	add_child(level)
	Transitions.fade_to_transparant()
	yield(Transitions, "transition_completed")
	
	for transition in level.transitions:
		transition.connect("interacted", self, "_on_transition_interacted")
	
	
func _on_transition_interacted(transition: Transition):
	print("Transitioning to ", transition.destination_path, transition.destination)
	var original_orientation: Vector2 = level.player.orientation
	
	if level != null:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
	reset_contents()
	
	level = transition.destination.instance()
	add_child(level)
	
	for marker in level.markers:
		if marker.tag == transition.marker_tag:
			level.player.position = marker.position
			
	level.player.set_orientation(original_orientation)
	
	Transitions.fade_to_transparant()
	yield(Transitions, "transition_completed")
	
	for transition in level.transitions:
		transition.connect("interacted", self, "_on_transition_interacted")
		
	
	
