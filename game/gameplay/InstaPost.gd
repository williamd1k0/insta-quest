extends TextureRect


func _ready():
	if OS.is_debug_build() and get_tree().root == get_parent():
		show_likes(50)

func add_comment(tex):
	$AnimationPlayer.play('reset')
	yield($AnimationPlayer, 'animation_finished')
	$Comment/Text.texture = tex
	$AnimationPlayer.play("show-comment")

func show_likes(likes):
	update_score(0)
	if likes > 0:
		$Tween.interpolate_method(
			self, 'update_score',
			0, likes, 2.0,
			Tween.TRANS_BOUNCE, Tween.EASE_IN, 1.0
		)
		$Tween.start()

func update_score(val):
	val = int(val)
	if val % 2 == 0 and val > 0 and not $Likes/Sfx.playing:
		$Likes/Sfx.play()
	$Likes/Score.text = str(val)
