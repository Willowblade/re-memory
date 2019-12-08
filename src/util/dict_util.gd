static func get_default(dictionary, key, default=null):
	"""Returns a default value or null if key is not present in dictionary""" 
	if not dictionary.has(key):
		return default
	return dictionary[key]

static func load_dictionary_from_json(filename):
	"""Loads a dictionary from a JSON file"""
	var dictionary = {}
	var file = File.new()
	
	file.open(filename, file.READ)
	dictionary = parse_json(file.get_as_text())
	file.close()

	return dictionary

static func save_dictionary_to_json(dictionary, filename):
	"""Stores a dictionary as a JSON file"""
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_line(to_json(dictionary))
	file.close()

static func save_dictionary_to_gd_constant(dictionary, constant_name, filename):
	"""Stores a dictionary as a JSON file"""
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_line("const " + constant_name + " = " + to_json(dictionary))
	file.close()

static func modify_array(original, modifications):
	"""Adds the modification elements to the original array"""
	for element in modifications:
		original.push_back(element)
