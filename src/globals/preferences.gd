extends Node

const DICT_UTIL = preload("res://src/util/dict_util.gd")


var preferences = {
	"volume": 1.00
}


var temporary_preferences = null

func _ready():
	print(AudioEngine.master_volume)
	var file = File.new()
	if file.file_exists("user://preferences.json"):
		preferences = DICT_UTIL.load_dictionary_from_json("user://preferences.json")
		
	temporary_preferences = preferences.duplicate(true)
		
func reset_temporary_preferences():
	temporary_preferences = preferences.duplicate(true)
	
func save_preferences():
	preferences = temporary_preferences
	DICT_UTIL.save_dictionary_to_json(preferences, "user://preferences.json")
	reset_temporary_preferences()
	
