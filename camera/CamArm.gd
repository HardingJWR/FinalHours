extends Spatial

onready var target = get_node("/root/Room/Player")

export var freeze_X : bool = false
export var min_X : float = 0
export var max_X : float = 0
export var freeze_Y : bool = false
export var min_Y : float = 0
export var max_Y : float = 0
export var freeze_Z : bool = false
export var min_Z : float = 0
export var max_Z : float = 0

func _physics_process(delta):
	pass
