extends Label


func _process(delta):
	if visible:
		text = '%02d:%02d' % [OS.get_time().hour, OS.get_time().minute]
