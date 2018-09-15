extends Control

enum { FANS, LIKES }

export(Color) var idx_color
export(Color) var n_color

func _ready():
	var temp = '[color=#{0}]#%s[/color]\n\t[color=#{1}]%s[/color] fans\n\t[color=#{1}]%s[/color] likes\n\n'.format([
		idx_color.to_html(false), n_color.to_html(false)
	])
	$ScrollText.bbcode_text = ''
	if 'insta_e' in Score.data:
		Score.data['insta_e'].sort_custom(self, 'sort_score')
		var i = 1
		for entry in Score.data['insta_e']:
			$ScrollText.bbcode_text += temp % [i, entry[FANS], entry[LIKES]]
			i += 1
	else:
		$ScrollText.bbcode_text = 'No score data.'

func sort_score(a, b):
	return a[FANS] > b[FANS]

