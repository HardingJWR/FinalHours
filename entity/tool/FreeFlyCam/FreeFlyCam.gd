extends Camera

var flyspeed = 10
var mouse_sens = 0.3
var camera_anglev=0
var rot_x = 0
var rot_y = 0
const LOOKAROUND_SPEED = 0.001

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready():
	# Initialization here
	self.set_process_input(true)
	self.set_process(true)
	#set mouse position


func _input(event):
	if event is InputEventMouseMotion:
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, -1, 0), rot_x) 
		rotate_object_local(Vector3(-1, 0, 0), rot_y) 



func _process(delta):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if(Input.is_key_pressed(KEY_P)):
		Infos.Current_Camera = self
	if(Input.is_key_pressed(KEY_I)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_K)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_J)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_L)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_U)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,1,0) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_M)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,1,0) * flyspeed * .01)
