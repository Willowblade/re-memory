extends Node2D
class_name Level

export var clock_speed = 1.0

export(String, FILE) var audio_track = ""


onready var tilemap = $Background/TileMap
onready var player = $Objects/PlayerCharacter
onready var clock = $Objects/PlayerCharacter/Camera/Clock

onready var ais = $AIs

onready var objects = $Objects.get_children()
onready var markers = $Markers.get_children()
onready var transitions = $Transitions.get_children()

onready var animation_player = $AnimationPlayer


onready var items = {
	"bookcase": $Objects/Bookcase,
	"carpet": $Objects/Carpet,
	"basket": $Objects/Basket,
	"tables": $Objects/Tables,
	"tv": $Objects/TV,
	"dresser": $Objects/Dresser,
	"treasure_box": $Objects/TreasureBox,
}

func run_start_code():
	pass
	
func _ready():
	Clock.speed_factor = clock_speed
	
	if audio_track != "" or audio_track != null:
		AudioEngine.play_background_music(audio_track)
	
	for object in objects:
		if object is Gate:
			object.update()
		if not object is CharacterController:
			continue
		print("Character ", object.name, " found")
		var tilemap_position = tilemap.world_to_map(object.position)
		object.position = tilemap.map_to_world(tilemap_position)
		
		var ai = object.generate_ai()
		ai.set_character(object)
		ais.add_child(ai)
	

	# this causes the scene to load its defaults
	play_animation("start")
	prepare_furniture()
	
	PlayerState.connect("updated_player_states", self, "_on_updated_player_states")
	
func prepare_furniture():
	for furniture in items:
		if items[furniture] != null:
			if furniture in PlayerState.unlocked_furniture:
				items[furniture].hide()
				items[furniture].get_node("KinematicBody2D").get_node("CollisionShape2D").disabled = true
				items[furniture].get_node("TextInteraction").disable()

func _on_updated_player_states():
	for object in objects:
		if object is Gate:
			object.update()
	
func play_animation(animation: String):
	if animation_player == null:
		Logger.error("Tried to play an animation on a level without AnimationPlayer...")
		return
	var animation_list = animation_player.get_animation_list()
	if not animation in animation_list:
		Logger.error("Tried to play an animation that doesn't exist in level. Animation name: %s" % [animation])
		return
		
	animation_player.play(animation)
	
	
func add_player_state(state: String):
	if state in items.keys():
		if not state in PlayerState.unlocked_furniture:
			PlayerState.unlocked_furniture.append(state)
	else:
		PlayerState.add_state_to_player_states(state)

