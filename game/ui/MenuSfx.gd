extends AnimationPlayer

enum MenuEvents {
	FOCUS=1, SELECT=2
}

export(int, FLAGS, "Focus", "Select") var parent_mode = 0

func _ready():
	if FOCUS & parent_mode:
		get_parent().connect('focus_entered', self, 'play', ['focus'])
	if SELECT & parent_mode:
		get_parent().connect('pressed', self, 'play', ['select'])
