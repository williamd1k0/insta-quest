extends Sprite

export(Vector2) var base_offset = Vector2(52, 10)
export(Vector2) var item_offset = Vector2(0, 16+4)
export(int) var max_items = 3
export(bool) var enabled = false
var selected = 0
onready var tween = $Tween

func _ready():
	update_cursor()

func _input(event):
	if enabled:
		if event.is_action_pressed('ui_up'):
			selected -= 1
			update_cursor()
		elif event.is_action_pressed('ui_down'):
			selected += 1
			update_cursor()

func update_cursor():
	if selected >= max_items:
		selected = 0
	elif selected < 0:
		selected = max_items-1
	tween.stop_all()
	tween.interpolate_property(
		self, 'position', 
		position, base_offset+item_offset*selected,
		0.2, Tween.TRANS_EXPO, Tween.EASE_OUT
	)
	tween.start()
	$MenuSfx.play('focus')

