extends Control

signal notify

onready var anime = $AnimationPlayer


func notify(text, icon=null):
	anime.play('reset')
	yield(anime, 'animation_finished')
	$Frame/Icon.texture = icon
	$Frame/Text.text = text
	anime.play('notify')
	yield(anime, 'animation_finished')
	emit_signal('notify')
	anime.play('reset')
