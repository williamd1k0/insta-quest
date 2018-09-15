extends "res://game/gameplay/minigames/MiniGameBase.gd"


func take_input():
	good_take = $Popuko.position.x >= 40
	$Bg/AnimationPlayer.stop()
	.take_input()
