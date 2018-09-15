extends 'res://game/gameplay/minigames/ItemSelectMiniGame.gd'


const ITEMS = [
	'Blue',
	'Green',
	'Orange',
	'Pink',
	'Purple',
	'Red'
]

func update_label(item):
	var c_rect = camera_rect.get_global_rect()
	var i_rect = item.get_node('Rect').get_global_rect()
	if abs(c_rect.position.x-i_rect.position.x) > abs(c_rect.end.x-i_rect.end.x):
		$Labels/Sprite.position = Vector2(2, 25)
	else:
		$Labels/Sprite.position = Vector2(43, 25)
