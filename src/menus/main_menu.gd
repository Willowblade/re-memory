extends Control


onready var main_buttons = {
	"start": get_node("MainMenu/Buttons/StartButton"),
	"options": get_node("MainMenu/Buttons/OptionsButton"),
	"exit": get_node("MainMenu/Buttons/ExitButton"),
}

onready var options_buttons = {
	"apply": get_node("Options/Buttons/ApplyButton"),
	"back": get_node("Options/Buttons/BackButton"),
}

onready var options_slider = {
	"volume": get_node("Options/Volume/Slider"),
}

onready var main_menu = get_node("MainMenu")
onready var options_menu = get_node("Options")

onready var current_menu = main_menu



func _ready():
	main_buttons["start"].connect("pressed", self, "_on_start_button_pressed")
	main_buttons["options"].connect("pressed", self, "_on_options_button_pressed")
	main_buttons["exit"].connect("pressed", self, "_on_exit_button_pressed")
	
	options_buttons["apply"].connect("pressed", self, "_on_apply_button_pressed")
	options_buttons["back"].connect("pressed", self, "_on_back_button_pressed")
	
	# when gets bigger, make options menu its own thing of course and move preferences there
	options_slider["volume"].connect("value_changed", self, "_on_volume_changed")
	print(Preferences.preferences)
	print(options_slider["volume"])
	options_slider["volume"].value = Preferences.preferences.volume * 100
	AudioEngine.play_sound("res://assets/audio/menu/menu.ogg")
	AudioEngine.set_master_volume(Preferences.preferences.volume)
	
func _on_start_button_pressed():
	Flow.go_to_game()
	
func _on_exit_button_pressed():
	Flow.quit()
	
func go_to_menu(menu):
	current_menu.hide()
	menu.show()
	current_menu = menu
	
func _on_options_button_pressed():
	Preferences.reset_temporary_preferences()
	go_to_menu(options_menu)
	
func _on_apply_button_pressed():
	Preferences.save_preferences()
	go_to_menu(main_menu)
	
func _on_back_button_pressed():
	AudioEngine.set_master_volume(Preferences.preferences.volume)
	options_slider["volume"].value = Preferences.preferences.volume * 100
	go_to_menu(main_menu)
	
func _on_volume_changed(new_volume):
	var volume_value = new_volume / 100
	Preferences.temporary_preferences.volume = volume_value
	AudioEngine.set_master_volume(volume_value)
	
	
