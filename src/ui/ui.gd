extends CanvasLayer


onready var menus = {
	"escape": get_node("EscapeMenu")
}

onready var dialogue = $Dialogue
onready var textbox = $Textbox
onready var clock = $Clock


var open_uis = []

func _ready():
	for child in get_children():
		if child != clock:
			child.hide()
			child.connect("close", self, "_on_close_ui")


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
	print("Should close")
	menu.hide()
	open_uis.erase(menu)
	if menu.should_pause:
		print("Resuming game")
		for open_ui in open_uis:
			if open_ui.should_pause:
				return
		Flow.resume()

func _physics_process(event):
	if Input.is_action_just_pressed("ui_menu"):
		open_ui("escape")

func show_text(text: String):
	Flow.pause()
	textbox.set_text(text)
	
	open_uis.append(textbox)
