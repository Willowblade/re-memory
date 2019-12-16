extends Level


onready var player_copy = $Objects/PlayerCharacter/Mirror
func _ready():
	pass


func _process(delta):
	player_copy.animation = player.animation.animation
	player_copy.frame = player.animation.frame
