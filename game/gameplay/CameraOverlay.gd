extends TextureRect

signal flash

onready var timer = $Timer

func camera(enabled):
	self_modulate = Color(1, 1, 1, 1) if enabled else Color(1, 1, 1, 0)

func set_time(factor):
	timer.rect_size = Vector2(64*factor, 2)

func flash():
	camera(true)
	$AnimationPlayer.play('flash')
	yield($AnimationPlayer, 'animation_finished')
	emit_signal('flash')
