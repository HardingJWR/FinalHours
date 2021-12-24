extends KinematicBody

export var weight : float = 1
export var size : float = 3
export var rotationBuffer : float = 0.5
export var alignBuffer : float = 0.25
export var pushX : bool = true
export var pushZ : bool = true

var around_the_box = false
var _body : KinematicBody
var aligned = false
var lookat = false
var interactable : bool = false
var is_pushing : bool = false

func _process(_delta):
	if interactable:
		is_pushing = Input.is_action_pressed("gp_interaction")
	
	if Input.is_action_just_released("gp_interaction"):
		is_pushing = false
		Global.set_player_control(true)


func _physics_process(_delta):
	if !is_instance_valid(_body):
		return
	
	#var direction : Vector3 = (transform.origin - _body.transform.origin).normalized()
	
	if around_the_box:
		aligned = Toolbox._is_aligned(_body.transform, transform, true, false, true, alignBuffer)
		lookat = Toolbox._is_front(_body.transform, transform, rotationBuffer)
	
	interactable = lookat && aligned
	
	if is_pushing:
		pushing()

func pushing():
	Global.set_player_control(false)
	var orientation = 0
	var cancelled : bool = true
	#Which side of the box we are
	var direction : Vector3 = (transform.origin - _body.transform.origin).normalized()
	if abs(direction.x) > abs(direction.z):
		if pushX:
			cancelled = false
			if direction.x > 0:
				direction = Vector3(1, 0, 0)
				orientation = 90
			if direction.x < 0:
				direction = Vector3(-1, 0, 0)
				orientation = 270
	if abs(direction.z) > abs(direction.x):
		if pushZ:
			cancelled = false
			if direction.z > 0:
				direction = Vector3(0, 0, 1)
				orientation = 0
			if direction.z < 0:
				direction = Vector3(0, 0, -1)
				orientation = 180
	
	#Align the player
	#push the box the other way
	if !cancelled:
		_body.transform.origin = to_global(direction * -size)
		_body.rotation.y = deg2rad(orientation)
		
		move_and_collide((direction * 0.035) / weight)


func _on_Area_body_entered(body):
	if body.name == "Player":
		_body = body
		around_the_box = true

func _on_Area_body_exited(body):
	if body.name == "Player":
		_body = null
		around_the_box = false
