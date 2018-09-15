extends 'res://game/gameplay/minigames/MiniGameBase.gd'


const ITEMS = [
	'Item1',
	'Item2',
	'ItemN',
]
export(NodePath) var itens_
var items = ITEMS.duplicate()
var current = items[0] # Debug only
var nav_speed = 1.0
onready var camera = $Camera
onready var camera_rect = $Camera/Rect
onready var item_count = get_node(itens_).get_child_count()

func _ready():
	init_row()
	._ready()

func _process(delta):
	if take_enabled:
		var move = arrow_input()
		move.y = 0
		camera.translate(move*nav_speed)
		camera.position.x = clamp(camera.position.x, 32, item_count*64-32)
		var selected = false
		for item in get_node(itens_).get_children():
			if not item.item_name in ITEMS:
				continue
			var item_select = camera_rect.encloses(item.get_node('Rect'))
			if not selected: selected = item_select
			item.select(item_select)
		nav_speed = 1.0 if selected else 1.5

func init_row():
	var items_nodes = get_node(itens_).get_children()
	items_nodes.shuffle()
	var i = 0
	for itn in items_nodes:
		itn.position.x = 64*i
		i+=1
	camera.position.x = item_count*64/2

func take_input():
	.take_input()

func post_take():
	set_process(false)
	for item in get_node(itens_).get_children():
		if camera_rect.encloses(item.get_node('Rect')):
			good_take = item.item_name == current
			item.get_node('DetectFrame').stop(1.4)
			update_label(item)
			break
	.post_take()

func update_label(item):
	# Dynamic label
	pass

func dynamic_hint():
	if items.empty():
		items = ITEMS.duplicate()
	items.shuffle()
	current = items[0]
	items.remove(0)
	return current+'!'

func get_data():
	return items

func set_data(data):
	items = data

