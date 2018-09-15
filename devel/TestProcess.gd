extends Node

export(String, FILE, '*.tscn') var minigame

const MiniGame = preload('res://game/gameplay/minigames/MiniGameBase.gd')

onready var camera = $Overlay/CameraOverlay
onready var post = $Overlay/InstaPost
onready var notify = $Overlay/Notify
var current_minigame
var minigame_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	new_minigame(minigame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_minigame:
		camera.set_time(current_minigame.time_status())

func _input(event):
	if event.is_action_pressed('take') and not current_minigame:
		new_minigame(minigame)

func new_minigame(path):
	clear_minigames()
	current_minigame = load(path).instance()
	if current_minigame.unique_name in minigame_data:
		 current_minigame.set_data(minigame_data[current_minigame.unique_name])
	$Minigame.add_child(current_minigame)
	current_minigame.connect('take', self, '_on_MiniGameTest_take')
	current_minigame.connect('camera', camera, 'camera')
	post.hide()
	camera.show()
	notify.notify(current_minigame.tip)
	yield(notify, 'notify')
	current_minigame.start()

func clear_minigames():
	current_minigame = null
	for c in $Minigame.get_children():
		c.queue_free()

func _on_MiniGameTest_take(by):
	prints('MiniGame:good-take', current_minigame.good_take)
	current_minigame.post_take()
	yield(current_minigame, 'post_take')
	camera.flash()
	yield(camera, 'flash')
	camera.hide()
	post.show()
	current_minigame.show_labels()
	if current_minigame.good_take:
		post.show_likes(current_minigame.get_likes())
		post.add_comment(current_minigame.good_comment)
	else:
		post.show_likes(0)
		post.add_comment(current_minigame.bad_comment)
	minigame_data[current_minigame.unique_name] = current_minigame.get_data()
	current_minigame = null
