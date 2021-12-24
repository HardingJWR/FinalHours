extends Spatial

export var IN_Camera_NP : NodePath
export var OUT_Camera_NP : NodePath
onready var CameraManager = get_parent()

var IN_camera : Camera
var OUT_camera : Camera

func _ready():
	if IN_Camera_NP == null && OUT_Camera_NP == null:
		print("MISSING CAMERA IN " + self.name)
	
	if IN_Camera_NP != "":
		IN_camera = get_node(IN_Camera_NP)
	
	if OUT_Camera_NP != "":
		OUT_camera = get_node(OUT_Camera_NP)


func _on_Area_body_entered(body):
	if IN_camera != null:
		if body.name == "Player":
			IN_camera.make_current()
			Infos.Current_Camera = IN_camera



func _on_Area_body_exited(body):
	if OUT_camera != null:
		if body.name == "Player":
			OUT_camera.make_current()
			Infos.Current_Camera = OUT_camera
