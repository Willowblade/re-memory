extends Control
class_name Textbox

export var characters_per_second = 15

onready var text_label = $TextLabel

var timer = 0

# TODO maybe work with state or so.
var completed = false

signal finished
signal close

func _ready():
	visible = false
	set_process(false)
	set_text(text_label.bbcode_text)

func _process(delta: float):
	handle_inputs(delta)

func handle_inputs(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		if completed:
			emit_signal("finished")
			emit_signal("close")
		else:
			text_label.visible_characters = text_label.get_total_character_count()
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
	set_process(true)
