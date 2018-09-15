extends NinePatchRect

var enframe_ = false

func _ready():
	hide()

func enframe(e):
	if e != enframe_:
		enframe_ = e
		$AnimationPlayer.play('enframe' if e else 'reset')

func stop(delay=0):
	if delay:
		yield(get_tree().create_timer(delay), "timeout")
	$AnimationPlayer.play('reset')
