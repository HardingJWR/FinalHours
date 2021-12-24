extends Control

onready var animationPlayer = get_node("ColorRect/AnimationPlayer")
export var scene : String

func _ready():
	$"Main/New Game".grab_focus()
	animationPlayer.play("FadeFromBlack")


#MAIN MENU
func _on_New_Game_pressed():
	$Main.visible = false
	animationPlayer.connect("animation_finished", self, "start_game")
	animationPlayer.play("FadeToBlack")

func _on_Options_pressed():
	$Main.visible = false
	$Options.visible = true
	$Options/GoBack.grab_focus()

func _on_Quit_pressed():
	$Main.visible = false
	$Leaving.visible = true
	$Leaving/NO.grab_focus()


#OPTIONS
func _on_GoBack_pressed():
	$Options.visible = false
	$Main.visible = true
	$Main/Options.grab_focus()


#LEAVING
func _on_YES_pressed():
	$Leaving.visible = false
	animationPlayer.connect("animation_finished", self, "quit_game")
	animationPlayer.play("FadeToBlack")

func _on_NO_pressed():
	$Leaving.visible = false
	$Main.visible = true
	$Main/Quit.grab_focus()


#Callback
func start_game(_arg0):
	Infos.spawnID = "01"
	Global.goto_scene(scene)

func quit_game(_arg0):
	get_tree().quit()
