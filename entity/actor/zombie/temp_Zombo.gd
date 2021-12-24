extends KinematicBody

const regular_speed = 4.5 

var gravity = 7
var physic : Vector3

#const acceleration_speed = 1.1
#var speed : float = 5 for later when we have acceleration and shit
var timer : float = 0
var memory_length: float = 10
var memory_timer = 0
var turning_speed : float = 0.5
var target : KinematicBody

var is_chasing : bool = false
var is_seeing : bool = false
var is_moving : bool = false

func _physics_process(delta):
	timer += delta
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(transform.origin + Vector3(0, 1, 0), Vector3(0, -20, 0), [self], 5)
	if result:
		pass
		transform.origin.y = result.position.y
	
	
	if !is_seeing:
		if timer >= memory_timer:
			is_chasing = false
	
	if is_chasing:
		chasing(delta)


func chasing(delta):
	var distance : float = self.transform.origin.distance_to(target.transform.origin)
	
	
	#if Toolbox._is_front(self.transform, target.transform, 0.3):
		#if distance < 2.5:
		#	Global.goto_scene("res://scene/gui/GAMEOVER.tscn")
	
	if Toolbox._is_front(self.transform, target.transform, 0.9):
		move_and_slide(transform.basis.z * regular_speed, Vector3.UP)
	#if is close by
		if distance < 10:
			if Toolbox._is_right(self.transform, target.transform, 1):
				rotate_y(-3 * delta * turning_speed)
			
			if Toolbox._is_left(self.transform, target.transform, 1):
				rotate_y(3 * delta * turning_speed)
			
	#if is far 
		if distance >= 10:
			if Toolbox._is_right(self.transform, target.transform, 0.8):
				rotate_y(-2 * delta * turning_speed)
			
			if Toolbox._is_left(self.transform, target.transform, 0.8):
				rotate_y(2 * delta * turning_speed)
	else:
		if Toolbox._is_right(self.transform, target.transform, 1):
			rotate_y(-3 * delta * turning_speed)
	
		if Toolbox._is_left(self.transform, target.transform, 1):
			rotate_y(3 * delta * turning_speed)

func _on_AreaSight_body_entered(body):
	if body.name == "Player":
		is_chasing = true
		is_seeing = true
		target = body

func _on_AreaSight_body_exited(body):
	if body.name == "Player":
		is_seeing = false
		memory_timer = timer + memory_length
