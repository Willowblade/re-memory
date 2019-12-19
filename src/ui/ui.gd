extends CanvasLayer


onready var menus = {
	"escape": get_node("EscapeMenu")
}

onready var dialogue = $Dialogue
onready var textbox = $Textbox
onready var clock = $Clock


var open_uis = []

signal closed

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
	print("Should close menu " + str(menu))
	menu.hide()
	open_uis.erase(menu)
	if menu == menus.escape:
		for open_ui in open_uis:
			open_ui.set_physics_process(true)
		Clock.start()
		
	if menu.should_pause:
		print("Resuming game")
		for open_ui in open_uis:
			if open_ui.should_pause:
				return
	
	if open_uis.empty():
		emit_signal("closed")
		Flow.resume()

func close_all_ui():
	if open_uis.size() > 0:
		for open_ui in open_uis:
			if open_ui is Dialogue:
				open_ui._exit()
			elif open_ui is Textbox:
				open_ui._exit()

func _physics_process(event):
	if Input.is_action_just_pressed("ui_menu"):
		if not menus.escape in open_uis: 
	#		if open_uis.size() == 0:
			Clock.stop()
			for open_ui in open_uis:
				open_ui.set_physics_process(false)
			open_ui("escape")
		else:
			_on_close_ui(menus.escape)
			

func show_text(text: String):
	Flow.pause()
	textbox.set_text(text)
	
	open_uis.append(textbox)
	
func show_dialogue(dialogue_path: String):
	Flow.pause()
	dialogue.set_dialogue_from_path(dialogue_path)
	
	open_uis.append(dialogue)
