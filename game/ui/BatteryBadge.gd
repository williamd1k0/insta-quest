extends Control

var current = 0

func _process(delta):
	if visible:
		update_badge()

func update_badge():
	var percent
	if OS.get_name() == 'HTML5':
		percent = 100
	elif OS.get_power_state() == OS.POWERSTATE_NO_BATTERY:
		percent = 100
	else:
		percent = OS.get_power_percent_left()
	if percent != current:
		current = percent
		$Percent.text = '%s%%' % percent
		var mins = calc_percent_size($Percent.text)
		if mins != rect_min_size:
			rect_min_size = mins
			rect_size = mins
		var bar = 3*(percent+10)/100
		$Icon/Bar.rect_size = Vector2(1, bar)
		$Icon/Bar.rect_position = Vector2(1, 4-bar)

func calc_percent_size(percent):
	var size = 3 # icon width
	for c in percent:
		size += 2 if c == '1' else 4
	return Vector2(size, 7)
