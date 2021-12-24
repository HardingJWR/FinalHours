extends Node

signal climbing

var perpendicularTarget : Position3D
var playerInside : bool = false
var playerBody : KinematicBody
export var x : bool = false
export var z : bool = false

func _ready():
	perpendicularTarget = $PerpendicularTarget

func _process(delta):
	if !Input.is_action_just_pressed("gp_interaction"):
		return
	
	if !playerInside:
		return
	
	if !is_player_aligned():
		return
	
	emit_signal("climbing")

func _on_Area_body_entered(body):
	playerInside = true
	playerBody = body

func _on_Area_body_exited(body):
	playerInside = false

func is_player_aligned() -> bool:
	if !x && !z:
		print("CLIMB TRIGGER NOT SET")
		return false
	
	var playerTransform : Transform = playerBody.global_transform
	var ptTransform : Transform = perpendicularTarget.global_transform
	
	#Align perpendicular target with player
	if x:
		perpendicularTarget.global_transform.origin.z = playerTransform.origin.z
	
	if z:
		perpendicularTarget.global_transform.origin.x = playerTransform.origin.x
	
	#Is the player looking at the perpendicular target
	if !Toolbox._is_front(playerTransform, ptTransform):
		return false
	
	return true
