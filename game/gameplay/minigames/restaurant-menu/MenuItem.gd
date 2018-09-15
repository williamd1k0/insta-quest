tool
extends Sprite

export(String) var item_name = '' setget set_item_name
export(Texture) var item_picture

func set_item_name(name_):
	item_name = name_
	call_deferred('update_item_name')

func update_item_name():
	$Name.text = item_name
	$Name.rect_position = Vector2(_edit_get_rect().size.x+1, 0)
