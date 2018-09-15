extends "res://game/gameplay/minigames/MiniGameBase.gd"

const screen = Rect2(0, 0, 64, 64)
var time = 0
onready var stick_point = $SelfieStick/SelfieStickPoint
onready var selfie_stick = $SelfieStick
onready var screen_rect = $SelfieStick/ScreenRect
onready var phone_rect = $SelfieStick/PhoneRect
onready var girl = $Girl
onready var girl_rect = $Girl/Sprite.region_rect


func _physics_process(delta):
	if take_enabled:
		time += delta
		if time >= 0.4/$Animation.playback_speed:
			girl.position += Vector2(-3+randi()%6+1, -3+randi()%6+1)
			time = 0
		var arrow = arrow_input()
		selfie_stick.position += arrow
		var rect = phone_rect.get_global_rect()
		if not screen.encloses(rect):
			selfie_stick.position.y = clamp(selfie_stick.position.y, 0, 64-rect.size.y)
			selfie_stick.position.x = clamp(selfie_stick.position.x, 0, 64-rect.size.x)
	update_girl_rect()
	update()

func update_girl_rect():
	var sr = screen_rect.get_global_rect()
	var gr = girl_rect
	sr.position = girl.to_local(sr.position)
	var intersection = sr.clip(gr)
	$Girl/Sprite.region_rect = intersection
	$Girl/Sprite.position = intersection.position - gr.position

func _draw():
	draw_line(Vector2(32, 65), to_local(stick_point.global_position), Color('#5f5750'), 1, 1)
	draw_line(Vector2(31, 65), to_local(stick_point.global_position)-Vector2(1, 0), Color('#5f5750'), 1, 1)

func post_take():
	good_take = $SelfieStick/Rect.encloses($Girl/Rect)
	set_physics_process(false)
	girl.hide()
	selfie_stick.hide()
	$TakeBg.show()
	$GoodTake.visible = good_take
	camera(true)
	.post_take()

