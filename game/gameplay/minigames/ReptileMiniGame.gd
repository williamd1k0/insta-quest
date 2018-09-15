extends "res://game/gameplay/minigames/MiniGameBase.gd"

func _process(delta):
	$Reptile/DetectFrame.enframe($TakeRect.encloses($Reptile/Rect))

func take_input():
	good_take = $TakeRect.encloses($Reptile/Rect)
	.take_input()

func post_take():
	set_process(false)
	$Reptile/DetectFrame.stop(1.4)
	.post_take()
