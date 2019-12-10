extends Textbox

const DICT_UTIL = preload("res://src/util/dict_util.gd")


onready var options = $Options.get_children()
onready var option_pointers = $OptionPointers.get_children()

var state = "text"

var _player_options: Array = []
var _dialogue
var _current_part

# for dialogue-specific state to print
var _states


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
		options[i].bbcode_text = player_options[i].text
		options[i].visible = true
		option_pointers[i].visible = true

	select_option(selected_option)
		
	visible = true
	set_physics_process(true)

func handle_inputs(delta: float):
	if state == "text":
		if not completed:
			timer += delta
			text_label.visible_characters = int(timer * characters_per_second)
			
			if text_label.visible_characters >= text_label.get_total_character_count():
				completed = true

	if Input.is_action_just_pressed("ui_accept"):
		handle_enter()
	if state == "options":
		if Input.is_action_just_pressed("ui_down"):
			select_option((selected_option + 1) % _player_options.size())
		if Input.is_action_just_pressed("ui_up"):
			select_option((selected_option - 1) % _player_options.size())

func handle_enter():
	if state == "text":
		if completed:
			timer = 0
			text_label.visible_characters = 0
			_progress()
		else:
			text_label.visible_characters = text_label.get_total_character_count()
			completed = true
	elif state == "options":
		chose_option()
	
func chose_option():
	var chosen_option = _player_options[selected_option]
	print("Chose option " + str(chosen_option))
	_on_option_chosen(chosen_option)
		
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
	for option_pointer in option_pointers:
		option_pointer.visible = false

	.set_text(text)


func _on_option_chosen(option):
	# TODO check for no-effect part
	if option.has("triggers_conditions") and option.triggers_conditions:
		# this whole shlock is for integer states. Could be cleaned up I'd wager...
		var old_values = {}
		for condition in option.triggers_conditions:
			for state in _states:
				if condition.begins_with(state):
					old_values[state] = PlayerState.get_value_for_state_with_value(state)

		PlayerState.add_states_to_player_states(option.triggers_conditions)	
		
		# TODO only works for dialogues with 1 value.
		if old_values:
			for old_value_prefix in old_values:
				var old_value = old_values[old_value_prefix]
				var new_value = PlayerState.get_value_for_state_with_value(old_value_prefix)
				if new_value == old_value and _dialogue.parts.has("no-effect"):
					Logger.info("No effect!")
					_set_current_part(_dialogue.parts["no-effect"])
					return
				elif new_value > _states[old_value_prefix].max and _dialogue.parts.has("max-reached"):
					_set_current_part(_dialogue.parts["max-reached"])
					return

	if option.has("next"):
		_set_current_part(_dialogue.parts[option.next])
	else:
		Logger.debug("Will exit as option does not have next")
		_exit()

func _set_options(options):
	var valid_options = []
	for option_properties in options:
		if not PlayerState.valid_conditions(option_properties.get("conditions", [])):
			Logger.info("Invalid option at this point: %s" % option_properties)
			continue
		Logger.info("Adding option %s" % option_properties)
		valid_options.append(option_properties)

	set_options(valid_options)

func _progress():	
	# to allow trigger condition layer choice before refactor (TBA)
	var triggered_conditions = _current_part.get("triggers_conditions", [])
	PlayerState.add_states_to_player_states(triggered_conditions)	

	var triggered_conditions_in_event = _current_part.get("event", {}).get("triggers_conditions", [])
	PlayerState.add_states_to_player_states(triggered_conditions_in_event)	

	if _current_part.has("options") and _current_part.options:
		Logger.debug("Has options! %s" % str(_current_part.options))
		_set_options(_current_part.options)
	else:
		if _current_part.has("event"):
			print("Playing event ", _current_part.event)
			emit_signal("event", _current_part.event)
	
		Logger.debug("Should go next or exit")
		if _current_part.has("next"):
			Logger.debug("Dialogue will progress to part %s" % _current_part.next)
			_set_current_part(_dialogue.parts[_current_part.next])
		else:
			Logger.debug("Will exit!")
			_exit()

	#print(get_node("MarginContainer/VBoxContainer/TextLabel").get("rect_size").y)


func _get_most_recent_entry():
	var most_recent_entry = null
	for entry in _dialogue.entries:
		var has_conditions = true
		for condition in entry.conditions:
			if not condition in PlayerState.player_states:
				has_conditions = false
				break
		if has_conditions:
			most_recent_entry = entry
	if most_recent_entry == null:
		Logger.error("There is no entry for current player state in dialogue %s" % _dialogue.name)
		return 
	return most_recent_entry.entry
	
func trigger_conditions(dialogue_part_or_option):
	if dialogue_part_or_option.has("triggers_conditions") and dialogue_part_or_option.triggers_conditions:
		PlayerState.add_states_to_player_states(dialogue_part_or_option.triggers_conditions)	

func set_content_label_text(label_text):
	if "%" in label_text:
		var split_text = label_text.split("%")
		# TODO could be done better I guess, with a loop etc, but eh. Not yet.
		var formatted_text = split_text[0] + str(PlayerState.get_value_for_state_with_value(split_text[1])) + split_text[2]
		set_text(formatted_text)
	else:
		set_text(label_text)

func _set_current_part(current_part):
	_current_part = current_part
	set_content_label_text(_current_part.text)

func set_dialogue_from_path(dialogue_script_path: String, part=null):
	var dialogue_script = DICT_UTIL.load_dictionary_from_json(dialogue_script_path)
	Logger.info("Loading dialogue from " + dialogue_script_path)
	set_dialogue(dialogue_script, part)

func set_dialogue(dialogue_script: Dictionary, part=null):
	_dialogue = dialogue_script
	_states = {}
	
	if _dialogue == null:
		Logger.error("Dialogue doesn't exist")
		# TODO maybe add this to the _exit function additionally?
		hide()
		yield(get_tree().create_timer(0.1), "timeout")
		_exit()
		return

	# this is for numerical states used in the dialogue or for printing.
	# clean code depending on final puzzles...
	if _dialogue.has("states"):
		for state_name in _dialogue.states:
			var state_prefix = "%s:%s" % [_dialogue.name, state_name]
			var state_properties = _dialogue.states[state_name]
			var state_prefix_in_player_states = false
			_states[state_prefix] = state_properties

			for player_state in PlayerState.player_states:
				if player_state.begins_with(state_prefix):
					state_prefix_in_player_states = true

			if state_prefix_in_player_states:
				Logger.info("Dialogue state value already in states!")
			else:
				Logger.info("Adding dialogue state to states")
				PlayerState.add_state_to_player_states("%s:%s" % [state_prefix, state_properties.value])
	else:
		Logger.info("No states present in dialogue?")

	if part == null:
		var entry = _get_most_recent_entry()
		if not entry in _dialogue.parts:
			Logger.error("Entry %s not in dialogue script" % entry)
			return
		Logger.debug("Chose entry %s" % entry)
		_set_current_part(_dialogue.parts[entry])
	else:
		_set_current_part(_dialogue.parts[part])
