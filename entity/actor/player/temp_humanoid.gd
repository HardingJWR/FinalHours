extends KinematicBody

#REACH TO GLOBAL FOR HITPOINTS AND ALL OTHER INFOS WHEN SPAWNING

#Preloads
onready var pre_pc = preload("res://entity/actor/player/temp_playercontroler.gd")

#References
var timer_control 
var player_control
var rayCast : RayCast
var rayCastClimb : RayCast 
var controlEnabled : bool

func _ready():
	controlEnabled = Global.playerControl
	rayCast = $RayCastGravity
	rayCastClimb = $RayCastClimb
	
	for child in get_tree().get_nodes_in_group("Climb"):
		child.connect("climbing", self, "_on_climb")
	
	_timers()
	_scripts()

func _physics_process(delta):
	if controlEnabled:
		player_control.Main(delta, self)
		
	_gravity()
	

func _on_timer_control_timeout():
	player_control._on_timer_timeout()

func _timers():
	timer_control = Timer.new()
	add_child(timer_control)
	timer_control.connect("timeout", self, "_on_timer_control_timeout")
	timer_control.one_shot = true

func _scripts():
	player_control = pre_pc.new()
	player_control.timer = timer_control

func _gravity():
	if rayCast:
		if rayCast.is_colliding():
			transform.origin.y = rayCast.get_collision_point().y

func _on_climb():
	var distance : float = 0
	var Origin : float = 0
	var Point : float = 0
	
	#CAN I LEAP?
	if !rayCastClimb:
		return
	
	if !rayCastClimb.is_colliding():
		return
	
	#IS THIS A CLIMBING SPOT?
	Origin = stepify(rayCastClimb.global_transform.origin.y, 0.01)
	Point = stepify(rayCastClimb.get_collision_point().y, 0.01)
	distance = abs(Origin - Point)
	
	#VALIDATE HEIGHT WITH SWITCH
	
	#TURN OFF CONTROL 
	#HIDE TRUE PLAYER
	#PLAY ANIMATION
	#CHANGE PLAYER POSITION TO NEW SPOT
	
	#SHOW DEBUG INFO
	#$Label.text = "Origin: " + str(Origin) 
	#$Label.text += "\nPoint: " + str(Point)
	#$Label.text += "\nDistance: " + str(distance)












