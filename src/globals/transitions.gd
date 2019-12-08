extends Node

const DEFAULT_DURATION = 1.5
const DEFAULT_COLOR = Color(0.0,0.0,0.0,0.0)

signal transition_completed

var is_opaque: bool = false

func _ready():
	set_process(false)
	reset()
	
	#fade_to_opaque(DEFAULT_COLOR, "TESTING...", DEFAULT_DURATION)
	#yield(self,"transition_completed")
	#fade_to_transparant(DEFAULT_DURATION)
	
func fade_to_opaque(color:Color = DEFAULT_COLOR, text: String = "", duration: float = DEFAULT_DURATION):
	$CanvasLayer/ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	$CanvasLayer/ColorRect.color = color
	$CanvasLayer/Label.text = text
	$Tween.interpolate_property($CanvasLayer/ColorRect, "color",
				Color(color.r, color.g, color.b, 0.0), 
				Color(color.r, color.g, color.b, 1.0),
				duration, Tween.TRANS_SINE , Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	is_opaque = true
	emit_signal("transition_completed")
	
func fade_to_transparant(duration: float = DEFAULT_DURATION):
	var color =  $CanvasLayer/ColorRect.color
	$Tween.interpolate_property($CanvasLayer/ColorRect, "color",
				Color(color.r, color.g, color.b, 1.0), 
				Color(color.r, color.g, color.b, 0.0), 
				duration, Tween.TRANS_SINE , Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	is_opaque = false
	emit_signal("transition_completed")
	
	reset()
		
func reset():
	$CanvasLayer/ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/ColorRect.color = DEFAULT_COLOR
	$CanvasLayer/Label.text = ""








