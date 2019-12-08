extends Node2D
class_name Level

onready var tilemap = $Background/TileMap
onready var player = $Objects/PlayerCharacter

onready var ais = $AIs

onready var objects = $Objects.get_children()
onready var markers = $Markers.get_children()
onready var transitions = $Transitions.get_children()

func _ready():
	for object in objects:
		if not object is CharacterController:
			continue
		print("Character ", object.name, " found")
		var tilemap_position = tilemap.world_to_map(object.position)
		object.position = tilemap.map_to_world(tilemap_position)
		
		var ai = object.generate_ai()
		ai.set_character(object)
		ais.add_child(ai)
		

