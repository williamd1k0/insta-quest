extends 'res://game/gameplay/minigames/MiniGameBase.gd'

func take_input():
	good_take = not $Sprite/Blur1.visible
	.take_input()
