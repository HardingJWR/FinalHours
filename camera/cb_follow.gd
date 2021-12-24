extends Camera

onready var player = get_node('/root/Room/Player')
var distance_from_player:Vector3

func _ready():
	distance_from_player = player.get_translation() - translation
	
	
func _process(delta):
	transform.origin = player.transform.origin - distance_from_player
	
