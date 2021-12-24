extends Spatial

onready var target = get_node("/root/Room/Player")

export var freezeX : bool = false
export var distanceX : float = 0
export var clampX : bool = false
export var minX : float = 0
export var maxX : float = 0

export var freezeY : bool = false
export var distanceY : float = 0
export var clampY : bool = false
export var minY : float = 0
export var maxY : float = 0

export var freezeZ : bool = false
export var distanceZ : float = 0
export var clampZ : bool = false
export var minZ : float = 0
export var maxZ : float = 0


var frozenX : float = 0
var frozenY : float = 0
var frozenZ : float = 0

func _ready():
	frozenX = transform.origin.x
	frozenY = transform.origin.y
	frozenZ = transform.origin.z

func _physics_process(_delta):
	if is_instance_valid(target):
		transform.origin = target.transform.origin + Vector3(distanceX, distanceY, distanceZ)
		
		if freezeX:
			transform.origin.x = frozenX
		
		if freezeY:
			transform.origin.y = frozenY
		
		if freezeZ:
			transform.origin.z = frozenZ
		
		if clampX:
			transform.origin.x = clamp(transform.origin.x, minX, maxX)
		
		if clampY:
			transform.origin.y = clamp(transform.origin.y, minY, maxY)
		
		if clampZ:
			transform.origin.z = clamp(transform.origin.z, minZ, maxZ)
		
