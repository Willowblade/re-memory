extends Control
class_name Textbox

export var characters_per_second = 15

onready var text_label = $TextLabel

var timer = 0

# TODO maybe work with state or so.
var completed = false

signal finished
signal close

var should_pause = true

func _ready():
	visible = false
	# this worked when these were just set_process.. and then physics process is always on...
	set_physics_process(false)

func _physics_process(delta: float):
	handle_inputs(delta)

func handle_inputs(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		print("Got the right input...")
		if completed:
			timer = 0
			text_label.visible_characters = 0
			emit_signal("finished")
			emit_signal("close", self)
		else:
			text_label.visible_characters = text_label.get_total_character_count()
			print("Keep going in this part")
			completed = true
			
	if not completed:
		timer += delta
		text_label.visible_characters = int(timer * characters_per_second)
		
		if text_label.visible_characters >= text_label.get_total_character_count():
			completed = true
		
func set_text(text: String):
	timer = 0
	text_label.bbcode_text = text
	visible = true
	completed = false
	set_physics_process(true)
