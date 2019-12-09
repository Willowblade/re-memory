extends Panel

const DICT_UTIL = preload("res://src/util/dict_util.gd")

var file : String = "res://assets/data/dialogues.json"

export var use_portraits = false

onready var text_label = $RichTextLabel

	
var current_dialogue_name = ""
var current_dialogue = {
	"parts": []
}
var current_line = 0

var should_pause = true

signal finished
signal close

func _ready():
	text_label.set_override_selected_font_color(true)
	visible = false
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_progress_dialogue"):
		continue_dialogue()

func initialize(information):
	show_dialogue(information.name)

func show_dialogue(dialogue_name):
	current_dialogue_name = dialogue_name
	var data_text = DICT_UTIL.load_dictionary_from_json(file)
	
	current_dialogue = data_text[dialogue_name]
	
	current_line = 0
	visible = true
	set_process(true)
	show_line()
	
	
func show_line():
	if current_line < len(current_dialogue.parts):
		var current_part = current_dialogue.parts[current_line]
		var speaker = current_part.speaker

		text_label.text = current_part.text
	else:
		end_dialogue()
#		NodeRegistry.player.end_dialogue()

func end_dialogue():
	if not is_processing():
		return
	set_process(false)
	current_line = len(current_dialogue.parts)
	visible = false
	trigger_event()
	emit_signal("finished")
	emit_signal("close")

func continue_dialogue():
	current_line += 1
	show_line()
	
func _on_skip_pressed():
	end_dialogue()

func trigger_event():
	match current_dialogue_name:
		"start":
			pass
		_:
			pass
