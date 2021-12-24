extends KinematicBody

const LJoy_DeadZone = 0.75

const regular_speed = 5 
const dashing_speed = 20 #17.5 
const backward_speed = 3
const dodging_speed = 20
const acceleration_speed = 1.1
const acceleration_dash = 1.25
const joystick_angle_lerp_speed = 5
const speed_multiplier = 2.5
const turning_speed = 1.5

const timer_dash = 0.5
const timer_dodge = 0.4


var is_dashing : bool = false
var is_dodging : bool = false
var has_been_released_dodge_dash : bool = true 

var speed = 9
var turn = 0
var movingPressed = false

var CamY = 0
var angle = 0

var velocity = Vector3()
var timer

func Main(delta, self_kinematicbody):
	velocity = Vector3()
	
	#Dodge Mechanic
	if !has_been_released_dodge_dash && Input.is_action_just_released("gp_Run"):
		has_been_released_dodge_dash = true
	
	
	if !is_dodging && !is_dashing:
		
		#Perspective Control - Left Joystick
		var Y_Axis = Input.get_joy_axis(0, 1)
		var X_Axis = Input.get_joy_axis(0, 0)
		
		var current_angle = rad2deg(Vector2(X_Axis, Y_Axis).angle()) + 180
		
		var direction: Vector3 = Vector3(X_Axis, 0, Y_Axis)

		var movingReleased = true if direction.length() <= 0.75 && movingPressed else false
		
		if movingReleased || abs(angle - current_angle) > 22.5:
			angle = current_angle
			if is_instance_valid(Infos.Current_Camera):
				CamY = Infos.Current_Camera.rotation.y
			#if Infos.Current_Camera != null:
			#CamY = self_kinematicbody.get_node("Camera").rotation.y
		
		#Dead Zone
		movingPressed = direction.length() >= 0.75
		
		#Moving with Joystick
		if movingPressed:
			var targetAngle = atan2(X_Axis, Y_Axis) * 57.29578 * delta + CamY
			self_kinematicbody.rotation.y = lerp_angle(self_kinematicbody.rotation.y, targetAngle, joystick_angle_lerp_speed * delta)
			velocity += self_kinematicbody.transform.basis.z
		
		# Dash
		#if has_been_released_dodge_dash:
		#	if Input.is_action_pressed("gp_Aim") && movingPressed && Input.is_action_just_pressed("gp_Run"):
		#		has_been_released_dodge_dash = false
		#		is_dashing = true
		#		$Timer.start(timer_dash)
		
		# Dodge
		#if (Input.is_action_pressed("gp_backward")) && Input.is_action_just_pressed("gp_Run"):
		#	is_dodging = true
		#	$Timer.start(timer_dodge)
		
		#Tank Control - DPAD
		if Input.is_action_pressed("ui_up"):
			velocity += self_kinematicbody.transform.basis.z
		elif Input.is_action_pressed("ui_down"):
			velocity -= self_kinematicbody.transform.basis.z
		
		turn = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	
	if is_dashing:
		velocity += self_kinematicbody.transform.basis.z
		speed = clamp(speed * acceleration_dash, 1, dashing_speed) if speed != 0.0 else 1.0
	
	if is_dodging:
		velocity -= self_kinematicbody.transform.basis.z
		turn = 0
		speed = dodging_speed
	
	velocity = velocity.normalized()
	
	var is_moving = (movingPressed || Input.is_action_pressed("ui_up"))
	
	#Speed 
	if Input.is_action_pressed("ui_down"):
		speed = clamp(speed * acceleration_speed, 1, backward_speed) if speed != 0.0 else 1.0
	elif Input.is_action_pressed("gp_Run") && is_moving:
		speed = clamp(speed * acceleration_speed, 1, regular_speed * speed_multiplier) if speed != 0.0 else 1.0
	elif  is_moving && !Input.is_action_pressed("gp_Run"):
		speed = clamp(speed * acceleration_speed, 1, regular_speed) if speed != 0.0 else 1.0
	else:
		speed = 0
	
	#Execute the result of the inputs
	if !Input.is_action_pressed("gp_Aim") || is_dashing:
		self_kinematicbody.move_and_slide(velocity * speed, Vector3.UP)
		self_kinematicbody.rotate_y(turn * delta * turning_speed)


func _on_timer_timeout():
	is_dashing = false
	is_dodging = false
	speed = 0
