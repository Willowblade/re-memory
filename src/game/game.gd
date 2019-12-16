extends Node2D

onready var ui = $UI

onready var levels = {
	"base": preload("res://src/level/levels/TestLevelBase.tscn"),
	"destination": preload("res://src/level/levels/TestLevelDestination.tscn"),
	"bedroom": preload("res://src/level/levels/Bedroom.tscn"),
	"empty": preload("res://src/level/DoorLevel.tscn"),
	"main": preload("res://src/level/levels/MainLevel.tscn"),
	"bedroom_wakeup": preload("res://src/level/BedroomWakeup.tscn"),
	"hospital_wakeup": preload("res://src/level/Hospital.tscn")
}

var level_path: String = ""
var level: Level

signal level_loaded

var debug = false

func _ready():
	game_start()
	ui.clock.connect("finished", self, "_on_clock_finised")

func _on_clock_finised():
	ui.clock.disconnect("finished", self, "_on_clock_finised")
	Clock.stop()

	
	if level != null:
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")

	PlayerState.num_resets += 1 
		
	ui.close_all_ui()
		
			
	reset_contents()
	
	if debug:
		level_path = "res://src/level/levels/DoorLevel.tscn"
		
		level = levels.empty.instance()
		add_child(level)
	else:
		if PlayerState.unlocked_furniture.size() < 7:
			level_path = "res://src/level/levels/BedroomWakeup.tscn"
			
			level = levels.bedroom_wakeup.instance()
			add_child(level)
		else:
			level_path = "res://src/level/levels/Hospital.tscn"
			ui.clock.hide()
			level = levels.hospital_wakeup.instance()
			add_child(level)
	
	PlayerState.reset()
	
	Transitions.fade_to_transparant()
	yield(Transitions, "transition_completed")
	
	PlayerState.reset()
	
	level.player.connect("interacted", self, "_on_player_interacted")
	
	Clock.reset()
	Clock.start()
	ui.clock.connect("finished", self, "_on_clock_finised")

#	level.run_start_code()
	if level is BedroomWakeup:
		if PlayerState.num_resets == 1:
			ui.show_text("Wake up.")
			yield(ui, "closed")
			yield(get_tree().create_timer(0.5), "timeout")
			level.set_awake()
			yield(get_tree().create_timer(0.5), "timeout")
			ui.show_text("The world went dark... And now I'm here again...")
			yield(ui, "closed")
		else:
			ui.show_text("Wake up.")
			yield(ui, "closed")
			level.set_awake()
			yield(get_tree().create_timer(0.5), "timeout")
			ui.show_text("I still haven't found everything... I'd better get to it.")
			yield(get_tree().create_timer(0.5), "timeout")
			yield(ui, "closed")
		
		level_path = "res://src/level/levels/Bedroom.tscn"
		_load_level(levels.bedroom)
		yield(self, "level_loaded")
		
	if level is Hospital:
		Clock.stop()

		ui.show_text("Wake up.")
		yield(ui, "closed")
		yield(get_tree().create_timer(0.5), "timeout")
		level.set_awake()
		yield(get_tree().create_timer(0.5), "timeout")
		ui.show_text("A hospital room...")
		yield(ui, "closed")
		yield(get_tree().create_timer(0.5), "timeout")
		ui.show_text("I remember... Playing on the street...")
		yield(ui, "closed")
		yield(get_tree().create_timer(2.0), "timeout")
		level.set_asleep()
		yield(get_tree().create_timer(1.0), "timeout")
		
		Transitions.fade_to_opaque()
		yield(Transitions, "transition_completed")
		reset_contents()
		Transitions.fade_to_transparant()
		yield(Transitions, "transition_completed")
		yield(get_tree().create_timer(0.5), "timeout")
		ui.show_text("Thanks for playing! We hope you enjoyed the experience. The game will exit now!")
		yield(ui, "closed")
		get_tree().quit()
	
func game_start():
	Clock.reset()
	Clock.stop()

	if debug:
		level_path = "res://src/level/levels/DoorLevel.tscn"
		
		_load_level(levels.empty)
	else:
		level_path = "res://src/level/levels/BedroomWakeup.tscn"
		_load_level(levels.bedroom_wakeup)
#	level_path = "res://src/level/DoorLevel.tscn"
#	level_path = "res://src/level/levels/MainLevel.tscn"
#	level_path = "res://src/level/levels/Bedroom.tscn"

#	_load_level(levels.main)

	yield(self, "level_loaded")
	if level is BedroomWakeup:
		ui.show_text("Ouch... My head... What happened, where am I...?")
		yield(ui, "closed")
		yield(get_tree().create_timer(0.5), "timeout")
		level.set_awake()
		yield(get_tree().create_timer(0.5), "timeout")
		ui.show_text("I think this is... My room... Everything seems to be missing")
		yield(ui, "closed")
		_load_level(levels.bedroom)
		yield(self, "level_loaded")
		
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
	
	emit_signal("level_loaded")
		
	
func _on_player_interacted(interaction: Interactable):
	print("Player interacted with ", interaction)
	if interaction is Transition:
		transition(interaction)
	elif interaction is TextInteraction:
		show_text(interaction)
	elif interaction is DialogueInteraction:
		show_dialogue(interaction)
	elif interaction is LeverInteraction:
		interaction.toggle()
		

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

		
	
	
