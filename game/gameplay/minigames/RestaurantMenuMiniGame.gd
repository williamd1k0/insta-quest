extends 'res://game/gameplay/minigames/MiniGameBase.gd'


# Just a simple set collection to do simple membership testing
class Set:
	var __set
	func _init():
		__set = []
	func add(item):
		if not item in __set:
			__set.append(item)
	func has(item):
		return item in __set
	func full(size):
		return __set.size() == size
	func clear():
		__set.clear()


const PAGE_SIZE = 3
const PAGE = preload('res://game/gameplay/minigames/restaurant-menu/Page.tscn')

export(bool) var can_flip = false
var page_selected = 0
var previous = Set.new()
var menu_pages = []
var flipping = false
var previous_page = 0
onready var item_count = $Items.get_child_count()


func _ready():
	init_pages()

func _input(event):
	if can_flip and not flipping and event.is_action_pressed('ui_right'):
		next_page()

func init_pages():
	var page_i = 0
	var page
	var items = $Items.get_children()
	items.shuffle()
	for item in items:
		if page_i >= PAGE_SIZE:
			page_i = 0
		if page_i == 0:
			page = PAGE.instance()
			page.connect('flip', self, '_on_Page_flip')
			menu_pages.append(page)
			$Pages.add_child(page)
		$Items.remove_child(item)
		page.add_item(item)
		page_i += 1
	page_selected = menu_pages.size()-1

func next_page():
	previous_page = page_selected
	page_selected += 1
	if page_selected >= menu_pages.size():
		page_selected = 0
	flipping = true
	menu_pages[previous_page].flip()

func post_take():
	$Cursor.enabled = false
	can_flip = false
	var selected_item = menu_pages[page_selected].get_item($Cursor.selected)
	var selected = selected_item.item_name
	print(selected)
	good_take = not previous.has(selected)
	previous.add(selected)
	$FoodTake/Food.texture = selected_item.item_picture
	$AnimationPlayer.play("take")
	yield($AnimationPlayer, "animation_finished")
	.post_take()


func get_data():
	return previous

func set_data(data):
	previous = data
	if previous.full(item_count):
		previous.clear()

func _on_Page_flip():
	$Pages.move_child(menu_pages[previous_page], 0)
	menu_pages[previous_page].reset()
	flipping = false
