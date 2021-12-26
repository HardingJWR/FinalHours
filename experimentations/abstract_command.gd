extends Node

class_name Command

var action : String = "Action"

func execute(actor : TestActor):
	if !is_instance_valid(actor):
		return
	
	if !actor.has_method(action):
		return
	
	funcref(actor, action).call_func()

func _init(Action : String):
	action = Action
