extends Spatial



onready var Player = get_node("Player")
onready var Spawn = get_node("Spawn")

func _ready():
	var SpawnPoint : Position3D = Spawn.get_node(Infos.spawnID) as Position3D
	Player.transform = SpawnPoint.transform
	Player.rotation = SpawnPoint.rotation
