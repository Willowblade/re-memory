extends Node2D

onready var ui = $UI

onready var levels = {
	"base": preload("res://src/level/levels/TestLevelBase.tscn"),
	"destination": preload("res://src/level/levels/TestLevelDestination.tscn"),
	"bedroom": preload("res://src/level/levels/Bedroom.tscn"),
	"door": preload("res://src/level/DoorLevel.tscn"),
}

var level_path: String = ""
var level: Level

func _ready():
	game_start()
	ui.clock.connect("finished", self, "_on_clock_finised")

func _on_clock_finised():
	Clock.stop()
	
	if level != null:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
	reset_contents()
	
	level_path = "res://src/level/DoorLevel.tscn"
	_load_level(levels.door)
	
	PlayerState.reset_player_states()
	
	Transitions.fade_to_transparant()
	yield(Transitions, "transition_completed")
	
	level.player.connect("interacted", self, "_on_player_interacted")
	
	Clock.reset()
	Clock.start()
	
	
func game_start():
	Clock.reset()
	Clock.stop()
	level_path = "res://src/level/DoorLevel.tscn"
	_load_level(levels.door)
	Clock.start()

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
	
	level.player.connect("interacted", self, "_on_player_interacted")
		
	
func _on_player_interacted(interaction: Interactable):
	print("Player interacted with ", interaction)
	if interaction is Transition:
		transition(interaction)
	elif interaction is TextInteraction:
		show_text(interaction)
	elif interaction is DialogueInteraction:
		show_dialogue(interaction)
		

func show_text(text_interaction: TextInteraction):
	text_interaction.deactivate()
	ui.show_text(text_interaction.text)
	yield(ui, "closed")
	text_interaction.activate()
	if text_interaction.animation:
		print("Should play animation")
		level.play_animation(text_interaction.animation)
	
func show_dialogue(dialogue_interaction: DialogueInteraction):
	ui.show_dialogue(dialogue_interaction.dialogue_path)
	yield(ui, "closed")
	if dialogue_interaction.animation:
		print("Should play animation")
		level.play_animation(dialogue_interaction.animation)
	
func transition(transition: Transition):
	print("Transitioning to ", transition.destination_path, transition.destination)
	var original_orientation: Vector2 = level.player.orientation
	
	if level_path == transition.destination_path:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
		
		for marker in level.markers:
			if marker.tag == transition.marker_tag:
				level.player.position = marker.position
			
		Transitions.fade_to_transparant()
		yield(Transitions, "transition_completed")
		
		return
		
	
	if level != null:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
	reset_contents()
	
	level = transition.destination.instance()
	level_path = transition.destination_path
	add_child(level)
	
	for marker in level.markers:
		if marker.tag == transition.marker_tag:
			level.player.position = marker.position
			
	level.player.set_orientation(original_orientation)
	
	Transitions.fade_to_transparant()
	yield(Transitions, "transition_completed")
	
	level.player.connect("interacted", self, "_on_player_interacted")

		
	
	
