extends 'res://game/gameplay/minigames/MiniGameBase.gd'

onready var pigeon = $Pigeon/Rect
onready var trect = $TakeRect


func _process(delta):
	$Pigeon/DetectFrame.enframe(trect.encloses(pigeon))

func take_input():
	good_take = trect.encloses(pigeon)
	.take_input()

func post_take():
	set_process(false)
	$Pigeon/DetectFrame.stop(1.4)
	$Pigeon/AnimationPlayer.stop()
	$Pigeon.frame = 0
	.post_take()
