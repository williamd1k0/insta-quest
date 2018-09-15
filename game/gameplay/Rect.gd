tool
extends Control

func _draw():
	if Engine.editor_hint or get_tree().debug_collisions_hint:
		draw_rect(Rect2(Vector2(), rect_size), Color(randf(), randf(), randf()), false)

func get_rect():
	return Rect2(rect_position, rect_size)

func encloses(rect_control):
	return get_global_rect().encloses(rect_control.get_global_rect())
