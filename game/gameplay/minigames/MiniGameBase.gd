extends Node2D

enum TakeBy { USER, TIMEOUT }
enum NotifyIcon { TAKE, DPAD }


signal take(by)
signal post_take
signal camera(enabled)

export(int) var base_likes = 1
export(int) var time_bonus = 0
export(String) var hint = 'Take!' setget , dynamic_hint
export(NotifyIcon) var notify_icon = 0
export(Texture) var good_comment
export(Texture) var bad_comment
export(bool) var take_enabled = true
export(bool) var camera_ = true setget camera
export(int, 'Disabled', 'Good', 'Bad') var comment_test = 0
export(String) var unique_name = name # Will be used for get/set data

var good_take = false
var takeinput = preload("res://game/gameplay/TakeInput.tscn").instance()
var time_left = 1.0
onready var debug_start = OS.is_debug_build() and get_parent() == get_tree().root

func _enter_tree():
	$Animation.connect('animation_finished', self, '_on_animation_finished')
	add_child(takeinput)
	takeinput.connect('take_pressed', self, 'take_input')
	$Labels.scale = Vector2()

func _ready():
	# Debug start
	if debug_start:
		start()

func dynamic_hint():
	return hint

func camera(enabled):
	camera_ = enabled
	call_deferred('emit_signal', 'camera', enabled)

func show_labels():
	$Labels.scale = Vector2(1, 1)

func take_input():
	# Override this in the sub-class with *super*
	if take_enabled:
		if comment_test:
			good_take = true if comment_test == 1 else false
		take(USER)

func take(by=USER):
	if by == TIMEOUT:
		time_left = 0.0
	else:
		time_left = time_status()
	takeinput.disable()
	$Animation.stop(false)
	emit_signal('take', by)
	if debug_start:
		post_take()

func start(speed=1.0):
	$Animation.play('minigame', -1, speed)
	takeinput.call_deferred('enable')

func set_data(data):
	# Data for "persistent" minigames, like the "restaurant menu" one
	pass

func get_data():
	return null

func post_take():
	yield(get_tree(), 'idle_frame')
	emit_signal('post_take')

func time_status():
	# Time left (factor)
	if $Animation.current_animation == 'minigame':
		var length = $Animation.current_animation_length
		return (length-$Animation.current_animation_position)/length
	return 1.0

func get_likes():
	return int(base_likes+time_bonus*time_left)*int(good_take) # Hacking to the gate

func arrow_input():
	var input = Vector2()
	if Input.is_action_pressed("ui_down"):
		input.y = 1
	elif Input.is_action_pressed("ui_up"):
		input.y = -1
	if Input.is_action_pressed("ui_right"):
		input.x = 1
	elif Input.is_action_pressed("ui_left"):
		input.x = -1
	return input

func _on_animation_finished(anim_name):
	if anim_name == 'minigame':
		take(TIMEOUT)
