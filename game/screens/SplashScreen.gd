extends Control


func _on_animation_finished(anim_name):
	get_tree().change_scene('res://game/screens/MainScreen.tscn')
