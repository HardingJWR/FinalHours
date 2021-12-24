tool
extends Spatial

#Required:
# Room <- "Humanoids" Group


##########################################################
#        MULTIPLE ANGLE STAIRS IDEA ABANDONNED           #
##########################################################
#DONT TRY  TO FIND CLOSEST BUT JUST THE NEXT LOGICAL STEP#
#MAYBE RATIO HAS THE KEY. OR INSTEAD GET DISTANCE IN     #
#VECTOR3 instead of from z/x to z/x                      #
##########################################################


export var UPDATE : bool = false
export var X : bool = false
export var Z : bool = false

var bodyList : Array
export var stepList : Array

func _on_Area_body_entered(body):
	if not Engine.editor_hint:
		if body.is_in_group("Humanoids") && !body.is_in_group("Stairs"):
			bodyList.append(body)
			body.add_to_group("Stairs")

func _on_Area_body_exited(body):
	if not Engine.editor_hint:
		if body.is_in_group("Humanoids"):
			bodyList.erase(body)
			body.remove_from_group("Stairs")

func _process(_delta):
	editor()
	if not Engine.editor_hint:
		var distances = [99, 99]
		var nodes = [Vector3(0,0,0), Vector3(0,0,0)]
		for child in bodyList:
			var body : Vector3 = child.transform.origin
			
			for step in stepList:
				var distance : float
				if X:
					distance = abs(body.x - to_global(step).x)
				
				if Z:
					distance = abs(body.z - to_global(step).z)
				
				#Get 2 closest points
				if distance <= distances[0]:
					distances[1] = distances[0]
					distances[0] = distance
					nodes[1] = nodes[0]
					nodes[0] = step
				elif (distance < distances[1] && distance != distances[0]):
					distances[1] = distance
					nodes[1] = step
			
			#DIVID INTO SMALL SECTIONS
			var top : Vector3 = to_global(nodes[1]) if nodes[1].y > nodes[0].y else to_global(nodes[0])
			var bottom : Vector3 = to_global(nodes[0]) if nodes[1].y > nodes[0].y else to_global(nodes[1])
			var ratio : float
			if X:
				ratio = (body.x - bottom.x) / (top.x - bottom.x)
				
			if Z:
				ratio = (body.z - bottom.z) / (top.z - bottom.z)
			ratio = clamp(ratio, 0, 1)
			
			var avg : float = (distances[0] + distances[1]) / 2
			
			#USE AVG TO KNOW IF IN BETWEEN FIRST AND LAST NODES
			#CHECK IF INBETWEEN LOWEST - 0.25 AND HIGHEST + 0.25
			var affected : bool = false
			var buffer : float = 0.25
			#HEIGHT PROXIMITY CHECK
			if body.y >= bottom.y - buffer && body.y <= top.y + buffer:
				if avg == 1.5:
					affected = true
			
			var nuHeight : float = abs(to_local(top).y - to_local(bottom).y)
			
			nuHeight = (nuHeight * ratio) + bottom.y 
			child.transform.origin.y = nuHeight


func editor():
	if Engine.editor_hint:
		if UPDATE:
			stepList.clear()
			for child in get_node("Steps").get_children():
					var step : Vector3 = child.transform.origin
					stepList.append(step)
			UPDATE = false
		
		if stepList.size() != get_node("Steps").get_child_count():
			stepList.clear()
			for child in get_node("Steps").get_children():
				var step : Vector3 = child.transform.origin
				stepList.append(step)
