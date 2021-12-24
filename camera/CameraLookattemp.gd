extends Camera 

onready var target = get_node("/root/Room/Player")

export var freezeX : bool = false
export var freezeY : bool = false
export var freezeZ : bool = false

var frozenX : float = 0
var frozenY : float = 0
var frozenZ : float = 0

func _ready():
	frozenX = rotation.x
	frozenY = rotation.y
	frozenZ = rotation.z

func _physics_process(_delta):
	if is_instance_valid(target):
		look_at(target.transform.origin, Vector3.UP)
		
		if freezeX:
			rotation.x = frozenX
		
		if freezeY:
			rotation.y = frozenY
		
		if freezeZ:
			rotation.z = frozenZ
		
