extends Control

onready var animationPlayer = get_node("ColorRect/AnimationPlayer")
export var scene : String

func _ready():
	$"Leaving/NO".grab_focus()
	animationPlayer.play("FadeFromBlack")

#LEAVING
func _on_YES_pressed():
	$Leaving.visible = false
	animationPlayer.connect("animation_finished", self, "quit_game")
	animationPlayer.play("FadeToBlack")

func _on_NO_pressed():
	$Leaving.visible = false
	animationPlayer.connect("animation_finished", self, "load_menu")
	animationPlayer.play("FadeToBlack")


#Callback
func quit_game(_arg0):
	get_tree().quit()

func load_menu(_arg0):
	Global.goto_scene(scene)
