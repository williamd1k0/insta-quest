extends Node2D

signal game_over

export(String, FILE, '*.tscn') var minigame_test
export(bool) var debug_ = false
export(Texture) var app_icon
export(Texture) var dpad_icon
export(Texture) var take_icon

const MiniGame = preload('res://game/gameplay/minigames/MiniGameBase.gd')
const MINIGAMES_PATH = 'res://game/gameplay/minigames/%sMiniGame.tscn'
const take_only_minigames = [
	'Reptile',
	'Popuko',
	'Pigeon',
	'Focus'
]
const dpad_minigames = [
	'SelfieStick',
	'Clothing',
	'RestaurantMenu',
	'Zoo'
]
const dpad_support = [
	'Windows', 'X11', 'HTML5'
]

onready var camera = $Overlay/CameraOverlay
onready var post = $Overlay/InstaPost
onready var notify = $Overlay/Notify
onready var debug = get_parent() == get_tree().root and OS.is_debug_build() and debug_
var current_minigame
var minigame_data = {}

const plus_fans = 100
var lifes = 3
var fans = 400*lifes
var max_fans = 0
var likes = 0
var prev_fans = fans
var notify_state = 0
var game_over = false

var current = -1
var speed = 1.0
var minigames = take_only_minigames.duplicate()

onready var notify_icons = {
	MiniGame.TAKE: take_icon,
	MiniGame.DPAD: dpad_icon,
}

func _ready():
	if OS.get_name() in dpad_support or not Input.get_connected_joypads().empty():
		minigames += dpad_minigames
	next_minigame()

func _process(delta):
	if current_minigame:
		camera.set_time(current_minigame.time_status())

func _input(event):
	if event.is_action_pressed('take') and not current_minigame:
		if not notify_state:
			notify_state = 1
			fans_notify()

func next_minigame():
	if debug:
		new_minigame(minigame_test)
	else:
		current += 1
		if current >= minigames.size():
			minigames.shuffle()
			current = 0
			speed += 0.1
			notify.notify('Speed up')
			yield(notify, 'notify')
		new_minigame(MINIGAMES_PATH%minigames[current])
	notify_state = 0


func new_minigame(path):
	clear_minigames()
	current_minigame = load(path).instance()
	$Minigame.add_child(current_minigame)
	if current_minigame.unique_name in minigame_data:
		 current_minigame.set_data(minigame_data[current_minigame.unique_name])
	current_minigame.connect('take', self, '_on_MiniGameTest_take')
	current_minigame.connect('camera', camera, 'camera')
	post.hide()
	camera.show()
	notify.notify(current_minigame.hint, notify_icons[current_minigame.notify_icon])
	yield(notify, 'notify')
	current_minigame.start(speed)

func clear_minigames():
	current_minigame = null
	for c in $Minigame.get_children():
		c.queue_free()

func update_fans(diff):
	prev_fans = fans
	fans = max(0, fans+diff)
	max_fans = max(max_fans, fans)
	game_over = fans == 0


func fans_notify():
	var notify_msg = ('+%s  fans'%plus_fans) if prev_fans<fans else ('-%s  fans'%[prev_fans-fans])
	notify.notify(notify_msg, app_icon)
	yield(notify, 'notify')
	notify.notify('%s  fans'%fans, app_icon)
	yield(notify, 'notify')
	if not game_over:
		next_minigame()
	else:
		game_over()

func game_over():
	if not 'insta_e' in Score.data:
		Score.data['insta_e'] = []
	Score.data['insta_e'].append([max_fans, likes])
	Score.save_data()
	notify.notify('Game Over')
	yield(notify, 'notify')
	emit_signal('game_over')

func _on_MiniGameTest_take(by):
	current_minigame.post_take()
	yield(current_minigame, 'post_take')
	$PostSfx.play('take')
	yield($PostSfx, 'animation_finished')
	camera.flash()
	yield(camera, 'flash')
	camera.hide()
	post.show()
	current_minigame.show_labels()
	if current_minigame.good_take:
		$PostSfx.play('good')
		likes += current_minigame.get_likes()
		post.show_likes(current_minigame.get_likes())
		post.add_comment(current_minigame.good_comment)
		update_fans(plus_fans)
	else:
		$PostSfx.play('bad')
		post.show_likes(0)
		post.add_comment(current_minigame.bad_comment)
		update_fans(-fans/lifes)
		lifes -= 1
	minigame_data[current_minigame.unique_name] = current_minigame.get_data()
	print(minigame_data)
	current_minigame = null
