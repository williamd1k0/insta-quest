extends Sprite

signal flip

const PAGE_FLIP = 2
const base_item_offset = Vector2(3, 6)
const item_offset = Vector2(0, 16+4)
var page_status = -1
onready var tween = $Tween


func _process(delta):
	if page_status >= 0:
		$Shadow.global_scale = Vector2(1, 1) # HACK

func add_item(item):
	$Items.add_child(item)
	item.position = base_item_offset+item_offset*($Items.get_child_count()-1)

func get_item(idx):
	return $Items.get_child(idx)

func flip():
	page_status = 0
	tween.interpolate_property(
		self, 'scale',
		Vector2(1, 1), Vector2(0, 1),
		0.6, Tween.TRANS_SINE, Tween.EASE_OUT_IN
	)
	tween.interpolate_method(
		self, 'set_shadow_size',
		Vector2(64, 64), Vector2(0, 64),
		0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN, 0.1
	)
	tween.start()
	$MenuSfx.play("back")

func set_shadow_size(size):
	$Shadow.region_rect.size = size+Vector2(16, 0)

func reset():
	scale = Vector2(1, 1)
	$Shadow.region_rect.size = Vector2(64, 64)

func _on_Tween_completed(object, key):
	page_status += 1
	if page_status == PAGE_FLIP:
		emit_signal('flip')
		page_status = -1
