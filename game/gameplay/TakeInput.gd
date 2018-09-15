extends Node

signal take_pressed

var can_take = false

func _input(event):
	if can_take and event.is_action_pressed('take'):
		emit_signal('take_pressed')

func enable():
	can_take = true

func disable():
	can_take = false
