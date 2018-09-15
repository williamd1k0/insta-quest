extends RichTextLabel

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		get_v_scroll().value-=1
	elif Input.is_action_pressed("ui_down"):
		get_v_scroll().value+=1

func _on_meta_clicked(meta):
	OS.shell_open(meta)
