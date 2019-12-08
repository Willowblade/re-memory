extends CenterContainer

var should_pause = true

signal close(menu)

onready var main_buttons = {
	"resume": get_node("PanelContainer/Contents/ResumeButton"),
	"exit_menu": get_node("PanelContainer/Contents/ExitMenuButton"),
	"exit_desktop": get_node("PanelContainer/Contents/ExitDesktopButton"),
}

func _ready():
	main_buttons["resume"].connect("pressed", self, "_on_resume_button_pressed")
	main_buttons["exit_menu"].connect("pressed", Flow, "go_to_main_menu")
	main_buttons["exit_desktop"].connect("pressed", Flow, "quit")

func _on_resume_button_pressed():
	print("Resume button pressed!")
	emit_signal("close", self)

func _on_exit_menu_button_pressed():
	emit_signal("close", self)
	Flow.go_to_main_menu()
	
func _on_exit_desktop_button_pressed():
	Flow.quit()