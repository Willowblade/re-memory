"""
Not sure if PlayerState is a better name than GameState at this point...

Keeps track of the player state. 

Contains an inventory in a prototype way. Ideally Inventory becomes a part of the state through composition
"""
extends Node

const DICT_UTIL = preload("res://src/util/dict_util.gd")

var inventory = []
var player_states = []

var unlocked_furniture = []


signal updated_inventory()
signal updated_player_states()

func valid_conditions(conditions: Array):
	for condition in conditions:
		Logger.debug("Condition %s is valid: %s" % [condition, has_condition(condition)])
		if not has_condition(condition):
			return false
	return true
	
func add_test_inventory():
	for item in ["key", "characters/person"]:
		add_item_to_inventory(DICT_UTIL.load_dictionary_from_json("res://assets/data/objects/{item}.json".format({"item": item})))

func add_test_player_states():
	add_states_to_player_states(["object:angry_guy:picked_up", "object:plant:looked_at","door:door_to_hell:unlocked"])
	
func test_negation_of_conditions():
	var condition_pulled = "lever-pulled"
	var condition_pulled_reverse = "!lever-pulled"
	add_states_to_player_states([condition_pulled, condition_pulled_reverse])
	Logger.info("Player states %s" % str(player_states))
	add_states_to_player_states([condition_pulled_reverse, condition_pulled])
	Logger.info("Player states %s" % str(player_states))

func _ready():
	# add_test_inventory()
	# add_test_player_states()
	# test_negation_of_conditions()
	pass
	
func add_item_to_inventory_from_path(item_path):
	Logger.info("Added item to inventory")
	var item = DICT_UTIL.load_dictionary_from_json(item_path)
	inventory.append(item)
	var state_string = "inventory:{item}".format({"item": item.name})
	if state_string in player_states:
		Logger.error("State {state} already in states".format({"state": state_string}))
	else:
		_add_state(state_string)
	
	emit_signal("updated_inventory")
	
func add_item_to_inventory(item):
	Logger.info("Added item %s to inventory" % str(item))
	inventory.append(item)
	var state_string = "inventory:{item}".format({"item": item.name})
	if state_string in player_states:
		Logger.error("State {state} already in states".format({"state": state_string}))
	else:
		_add_state(state_string)
	
	emit_signal("updated_inventory")

func remove_item_from_inventory(item):
	inventory.erase(item)
	
	emit_signal("updated_inventory")
	
func _add_state(state: String):
	Logger.info("Adding state %s" % state)
	if state.begins_with("inventory-lose:"):
		var item_name = state.split(":")[1]
		for item in inventory:
			if item.name == item_name:
				Logger.info("Removing item %s!" % item_name)
				remove_item_from_inventory(item)
	elif state.begins_with("inventory-get:"):
		var item_name = state.split(":")[1]
		Logger.info("Adding item %s from path in objects folder, make sure it exists" % item_name)
		var item_path = "res://assets/data/objects/%s.json" % item_name
		add_item_to_inventory_from_path(item_path)
	elif state.begins_with("!") and state.substr(1, state.length() - 1) in player_states:
		Logger.info("Removed the one previously without !")
		player_states.erase(state.substr(1, state.length() - 1))
		return
	elif "!" + state in player_states:
		Logger.info("Removed the one state previously with !")
		player_states.erase("!" + state)
		return
	else:
		if is_integer_value_state(state):
			Logger.info("Adding integer value state %s" % state)
			_add_integer_value_state(state)
			return
	Logger.info("Added state %s" % state)
	player_states.append(state)
	
func add_state_to_player_states(state: String):
	Logger.info("Added a state: %s" % state)
	_add_state(state)
	emit_signal("updated_player_states")
	
func add_states_to_player_states(states: Array):
	if len(states) == 0:
		return
	Logger.info("Added states: %s" % str(states))
	for state in states:
		_add_state(state)
	emit_signal("updated_player_states")
	
func _remove_state(state):
	player_states.erase(state)
	
func remove_state_from_player_states(state):
	Logger.info("Removed a state: %s" % state)
	_remove_state(state)
	emit_signal("updated_player_states")
	
func remove_states_from_player_states(states: Array):
	if len(states) == 0:
		return
	Logger.info("Removed states: %s" % str(states))
	for state in states:
		_remove_state(state)
	emit_signal("updated_player_states")

func reset_player_states():
	Logger.info("Resetting player state")
	var removed = []
	for state in player_states:
		if not "permanent" in state:
			removed.append(state)
			_remove_state(state)
	Logger.info("Removed states: %s" % str(removed))
	Logger.info("Remaining states: %s" % str(player_states))

func reset():
	inventory.clear()
	emit_signal("updated_inventory")
	player_states.clear()
	emit_signal("updated_player_states")
		
	
func has_condition(condition: String):
	if is_integer_value_state(condition):
		# TODO would be a nice moment to work with classes for these parsed player states?
		var valid_condition = false
		var splitted_state = condition.split(":")
		var prefix = ""
		for i in range(splitted_state.size()):
			if i == splitted_state.size() - 1:
				continue
			elif i == splitted_state.size() - 2:
				prefix += splitted_state[i]
			else:
				prefix += splitted_state[i] + ":"
		var value_part = splitted_state[-1]
		var operation = "="
		if value_part.begins_with("<"):
			Logger.debug("Value starts with <")
			operation = "<"
			value_part = value_part.substr(1, value_part.length() - 1)
		elif value_part.begins_with(">"):
			Logger.debug("Value starts with >")
			operation = ">"
			value_part = value_part.substr(1, value_part.length() - 1)
		
		var existing_state = state_with_value(prefix, prefix + ":0")
		if existing_state == null:
			Logger.debug("State %s doesn't exist yet, will always be false" % prefix)
			valid_condition = false
		else:
			var current_value = get_value_for_state(existing_state)
			var expected_value = get_value_for_state(condition)
			if operation == "=":
				Logger.debug("Doing an equality compare for condition with current value %s and compared state %s, expected value %s and result %s" % [current_value, existing_state, expected_value, current_value == expected_value])
				valid_condition = current_value == expected_value
			elif operation == ">":
				Logger.debug("Doing a larger than compare for condition with current value %s and compared state %s, expected value %s and result %s" % [current_value, existing_state, expected_value, current_value > expected_value])
				valid_condition = current_value > expected_value
			elif operation == "<":
				Logger.debug("Doing a smaller than compare for condition with current value %s and compared state %s, expected value %s and result %s" % [current_value, existing_state, expected_value, current_value < expected_value])
				valid_condition = current_value < expected_value
				
		if condition.begins_with("!"):
			return not valid_condition
		else:
			return valid_condition

	if condition.begins_with("!"):
		var true_condition_not_present = not condition.substr(1, condition.length() - 1) in player_states
		return condition in player_states or true_condition_not_present

	return condition in player_states
	
	
func get_value_for_state_with_value(state_prefix):
	Logger.debug("Getting value for state " + state_prefix)
	return get_value_for_state(state_with_value(state_prefix))

func get_value_for_state(state):
	return get_value_part_of_state(state).to_int()

func has_state_with_prefix(prefix):
	for player_state in player_states:
		if player_state.begins_with(prefix):
			return true
	return false

func state_with_value(state_name, default=null):
	for player_state in player_states:
		if player_state.begins_with(state_name):
			return player_state
	if default != null:
		_add_integer_value_state(default)
	return default
	
func get_value_part_of_state(state):
	var value_part = state.split(":")[-1]
	if value_part.begins_with("+"):
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with("-"):
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with("<"):
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with(">"):
		value_part = value_part.substr(1, value_part.length() - 1)
	return value_part

func is_integer_value_state(state):
	return get_value_part_of_state(state).is_valid_integer()

func _add_integer_value_state(state):
	# parse relevant parts
	var splitted_state = state.split(":")
	var prefix = ""
	for i in range(splitted_state.size()):
		if i == splitted_state.size() - 1:
			continue
		elif i == splitted_state.size() - 2:
			prefix += splitted_state[i]
		else:
			prefix += splitted_state[i] + ":"
	var value_part = splitted_state[-1]
	var operation = "="
	if value_part.begins_with("="):
		Logger.debug("Value starts with =")
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with("+"):
		Logger.debug("Value starts with +")
		operation = "+"
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with("-"):
		Logger.debug("Value starts with -")
		operation = "-"
		value_part = value_part.substr(1, value_part.length() - 1)
	elif value_part.begins_with("<"):
		Logger.debug("Value starts with <")
		operation = "="
		value_part = str(int(value_part.substr(1, value_part.length() - 1)) - 1)
	elif value_part.begins_with(">"):
		Logger.debug("Value starts with >")
		operation = "="
		value_part = str(int(value_part.substr(1, value_part.length() - 1)) + 1)
		
	var existing_state = state_with_value(prefix)
	if existing_state == null:
		if not operation in ["="]:
			Logger.error("State %s can't be used as value has not been created" % state)
		else:
			player_states.append(prefix + ":" + value_part)
	elif operation == "=":
		player_states.erase(existing_state)
		player_states.append(prefix + ":" + value_part)
	elif operation == "+":
		Logger.debug("It's a plus and the new value is")
		var current_value = get_value_for_state(existing_state)
		var new_value = current_value + int(value_part)
		Logger.debug(str(new_value))
		Logger.debug("New state " + prefix + ":" + str(new_value))
		player_states.erase(existing_state)
		player_states.append(prefix + ":" + str(new_value))
	elif operation == "-":
		var current_value = get_value_for_state(existing_state)
		var new_value = max(current_value - int(value_part), 0)
		player_states.erase(existing_state)
		player_states.append(prefix + ":" + str(new_value))

	Logger.debug("Player states: %s" % str(player_states))

	
