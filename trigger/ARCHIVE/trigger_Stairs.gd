extends Spatial

var affectedBodies : Array
export var direction : Vector3
export var ground : float = 0
export var height : float = 1
export var buffer : float = 1
onready var area : CollisionShape = get_node("Area/CollisionShape")

var TEST : String = ""


#heightMax doesnt mean 1 to global but +1 to heightMin (I think)

func _on_Area_body_entered(body):
	
	if body.name == "Player":
		affectedBodies.append(body)

func checkPosition(var body : KinematicBody):
	if !(body.transform.origin.y >= -0.3+ ground && body.transform.origin.y <= height + 0.3):
		return false 
	
	if direction.x == 1:
		#if player >= zero+buffer
		var result : float = (to_global(area.transform.origin).x - area.scale.x) - buffer
		
		if (body.transform.origin.x >= result):
			return true
	
	if direction.x == -1:
		
		#var zero : float = to_global(area.transform.origin).x - areaLenght
		pass
	
	
	if direction.z == 1:
		pass
		#var zero : float = to_global(area.transform.origin).z + (areaLenght / 2)
	
	if direction.z == -1:
		pass
		#var zero : float = to_global(area.transform.origin).z - areaLenght
	
	return false

func _on_Area_body_exited(body):
	if body.name == "Player":
		if affectedBodies.find(body) != -1:
			affectedBodies.erase(body)

func _physics_process(_delta):
	if affectedBodies.size() > 0:
		for child in affectedBodies:
			var kBody : KinematicBody = child
			_elevation(kBody)

func _elevation(var target : KinematicBody):
	TEST = str(target.transform.origin.x)
	var _areaCenter : float 
	var areaLenght : float 
	var progression : float
	
	if direction.x == 1:
		areaLenght = area.scale.x
		
		var zero : float = to_global(area.transform.origin).x + (areaLenght / 2)
		
		if target.transform.origin.x > zero:
			progression = 0
		else:
			progression = abs(target.transform.origin.x - zero)
			progression = progression / (areaLenght * 2)
		
		if progression >= 1:
			 progression = 1
		
		target.transform.origin.y = (ground + ((height - ground) * progression))
	
	if direction.x == -1:
		areaLenght = area.scale.x
		
		var zero : float = to_global(area.transform.origin).x - areaLenght
		
		if target.transform.origin.x < zero:
			progression = 0
		else:
			progression = abs(target.transform.origin.x - zero)
			progression = progression / (areaLenght * 2)
		
		if progression >= 1:
			 progression = 1
		
		target.transform.origin.y = (ground + ((height - ground) * progression))
	
	
	if direction.z == 1:
		areaLenght = area.scale.z
		
		var zero : float = to_global(area.transform.origin).z + (areaLenght / 2)
		
		if target.transform.origin.z > zero:
			progression = 0
		else:
			progression = abs(target.transform.origin.z - zero)
			progression = progression / (areaLenght * 2)
		
		if progression >= 1:
			 progression = 1
		
		target.transform.origin.y = (ground + ((height - ground) * progression))
	
	if direction.z == -1:
		areaLenght = area.scale.z
		
		var zero : float = to_global(area.transform.origin).z - areaLenght * 2
		
		if target.transform.origin.z < zero:
			progression = 0
		else:
			progression = abs(target.transform.origin.z - zero)
			progression = progression / (areaLenght * 4)
		
		if progression >= 1:
			 progression = 1
		
		target.transform.origin.y = (ground + ((height - ground) * progression))
		

