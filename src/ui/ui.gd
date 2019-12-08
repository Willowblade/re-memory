extends CanvasLayer


onready var menus = {
	"escape": get_node("EscapeMenu")
}

var enabled = false

var open_uis = []

func _ready():
	disable()
	for child in get_children():
		child.hide()
		child.connect("close", self, "_on_close_ui")

func enable():
	enabled = true
	set_process_input(true)

func disable():
	enabled = false
	set_process_input(false)

func reset():
	for child in get_children():
		child.hide()
	open_uis.clear()
	Flow.resume()

func open_ui(ui_name, information=null):
	# naming is a soupie here.
	var menu = menus[ui_name]
	if information:
		menu.initialize(information)
	menu.show()
	if menu.should_pause:
		Flow.pause()
		
	open_uis.append(menu)

func _on_close_ui(menu):
	menu.hide()
	open_uis.erase(menu)
	if menu.should_pause:
		for open_ui in open_uis:
			if open_ui.should_pause:
				return
		Flow.resume()

func _input(event):
	if not enabled:
		print("Something wrong with UI")
		return
		
	if Input.is_action_just_pressed("ui_menu"):
		open_ui("escape")