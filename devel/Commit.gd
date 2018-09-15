extends Label

func _ready():
	visible = OS.is_debug_build()
	text = '@'+Engine.get_version_info()['hash'].substr(0, 7)
