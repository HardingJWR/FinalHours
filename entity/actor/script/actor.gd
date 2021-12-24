extends KinematicBody

class_name Actor

#Infos
export var idName : String = "John Doe"
export(int, FLAGS, "French", "English", "Zombie") var language = 0
export(int, FLAGS, "Army", "Police", "Neutral", "Criminal", "Zombie") var ally = 0

var zombified : bool = false
var dead : bool = false

var blood : float = 4.5 #Liquid
var stamina : float = 7200 #Seconds
var infection : float = 1000 #Seconds
var infection_rate : float = 0 #Per Seconds

var inventory = []

#Mechanics
var rayCast_gravity : RayCast
var rayCast_climb : RayCast

func _init():
	raycast_gravity()
	raycast_climb()


func raycast_gravity():
	rayCast_gravity = RayCast.new()
	rayCast_gravity.name = "RaycastGravity"
	rayCast_gravity.transform.origin = Vector3(0, 2, 0)
	rayCast_gravity.cast_to = Vector3(0, -5, 0)
	rayCast_gravity.set_collision_mask_bit(0, false)
	rayCast_gravity.set_collision_mask_bit(4, true)
	add_child(rayCast_gravity)

func raycast_climb():
	rayCast_climb = RayCast.new()
	rayCast_climb.name = "RaycastClimb"
	rayCast_climb.transform.origin = Vector3(0, 4.5, 2)
	rayCast_climb.cast_to = Vector3(0, -9, 0)
	rayCast_climb.set_collision_mask_bit(0, false)
	rayCast_climb.set_collision_mask_bit(4, true)
	add_child(rayCast_climb)

