extends Node

onready var actor : TestActor = get_parent().get_node("Player")

var button_up : Command
var button_up_hold : Command
var button_left : Command
var button_right : Command
var button_down : Command

func _ready():
	var jump : Command = Command.new("is_Just_Jump")
	var jumping : Command = Command.new("is_Jump")
	var run : Command = Command.new("Run")
	var speak : Command = Command.new("Speak")
	
	button_up = jump
	button_up_hold = jumping
	button_left = Command.new("Empty")
	button_right = run
	button_down = speak

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		button_up_hold.execute(actor)
	
	if Input.is_action_just_pressed("ui_up"):
		button_up.execute(actor)
	
	if Input.is_action_just_pressed("ui_left"):
		button_left.execute(actor)
	
	if Input.is_action_just_pressed("ui_right"):
		button_right.execute(actor)
	
	if Input.is_action_just_pressed("ui_down"):
		button_down.execute(actor)
