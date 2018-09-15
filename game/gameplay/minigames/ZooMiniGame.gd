extends 'res://game/gameplay/minigames/ItemSelectMiniGame.gd'


const ITEMS = [
	'Giraffe',
	'Ostrich',
	'Gorilla',
	'Lemur',
	'Red Panda'
]

func update_label(item):
	if item.item_name == 'Gorilla':
		$Labels/Sprite.position = Vector2(44, 4)
	else:
		$Labels/Sprite.position = Vector2(2, 4)