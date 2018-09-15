extends Control

signal splash

func _enter_tree():
	reset()

func _ready():
	if OS.is_debug_build() and get_parent() == get_tree().root:
		splash($App.text, $Icon.texture, $Bg.color, Vector2(32, 32))

func reset():
	$Bg.rect_size = Vector2()
	$App.hide()
	$Icon.hide()

func splash(app, icon, bg, at=Vector2()):
	reset()
	$App.text = app
	$Icon.texture = icon
	$Bg.color = bg
	at = at - rect_global_position
	$Tween.interpolate_method(
		self, 'set_bg_pos',
		at, Vector2(0, 0),
		1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.interpolate_method(
		self, 'set_bg_size',
		Vector2(), Vector2(64, 64),
		1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, 'tween_completed')
	$App.show()
	$Icon.show()
	yield(get_tree().create_timer(2.0), "timeout")
	reset()
	emit_signal('splash')

func set_bg_pos(pos):
	$Bg.rect_position = pos

func set_bg_size(size):
	$Bg.rect_size = size
