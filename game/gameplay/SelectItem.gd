extends Sprite

export(String) var item_name = ''
export(bool) var auto_update_rect = true
var selected = false

func _ready():
	if auto_update_rect:
		$DetectFrame.rect_position = $Rect.rect_position-Vector2(1, 0)
		$DetectFrame.rect_size = $Rect.rect_size+Vector2(1, 1)

func select(s):
	selected = s
	$DetectFrame.enframe(s)
