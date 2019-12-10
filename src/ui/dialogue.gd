extends Textbox

onready var options = $Options.get_children()
onready var option_pointers = $OptionPointers.get_children()

var state = "text"

var _player_options: Array = []
var _dialogue
var _current_dialogue

var selected_option: int = 0

func _ready():
	for option in options:
		option.visible = false
		
#	set_options(["Option 1", "Another option"])
#	set_options(["Option 1", "Another option", "A third option"])
#	set_options(["Option 1", "Another option", "A third option", "Even a fourth option"])
	
	
func set_options(player_options):
	state = "options"
	_player_options = player_options
	
	text_label.visible = false
	for i in range(options.size()):
		options[i].visible = false
		option_pointers[i].visible = false
	
	for i in range(player_options.size()):
		options[i].bbcode_text = player_options[i]
		options[i].visible = true
		option_pointers[i].visible = true

	select_option(selected_option)
		
	visible = true
	set_process(true)
		

func handle_inputs(delta: float):
	if state == "text":
		.handle_inputs(delta)
	elif state == "options":
		if Input.is_action_just_pressed("ui_accept"):
			
			chose_option()
			emit_signal("finished")
			emit_signal("close", self)
		if Input.is_action_just_pressed("ui_down"):
			select_option((selected_option + 1) % _player_options.size())
		if Input.is_action_just_pressed("ui_up"):
			select_option((selected_option - 1) % _player_options.size())
				
func set_dialogue(dialogue: Dictionary):
	_dialogue = dialogue
	# Work with conditions here and entries just like in DNVASA
	_current_dialogue = null
	
func chose_option():
	print("Chose option " + str(selected_option))
		
func select_option(index: int):
	selected_option = index
	if selected_option < 0:
		selected_option += _player_options.size()
	print(selected_option)

	for i in range(_player_options.size()):
		if i == selected_option:
			option_pointers[i].bbcode_text = "[X]"
		else:
			option_pointers[i].bbcode_text = "[   ]"

func set_text(text: String):
	state = "text"
	for option in options:
		option.visible = false
	.set_text(text)
