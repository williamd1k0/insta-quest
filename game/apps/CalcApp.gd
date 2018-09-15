extends Control

# A simple calculator app programmed in XGH

enum Symbols {
	S_MULT, S_DIV, S_MIN, S_PLUS,
	S_PERCENT, S_POW, S_SQRT, S_CLEAR
}

const SYM = {
	S_MULT: '×', S_DIV:'÷', S_MIN: '-', S_PLUS: '+',
	S_PERCENT: '%', S_POW: '^', S_SQRT: '√', S_CLEAR: 'c'
}
const NUMS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
const BASIC = ['×', '÷', '-', '+']
const STRIP_F = ['×', '÷', '+', '%', '^']
const STRIP_B = ['×', '÷', '-', '+', '%', '^', '√']
var line = ''

func _enter_tree():
	for n in $Nums.get_children():
		n.connect('pressed', self, '_on_Button_pressed', [n.text])
		n.connect('pressed', $MenuSfx, 'play', ['select'])
		n.connect('focus_entered', $MenuSfx, 'play', ['focus'])
	for o in $Ops.get_children():
		o.connect('pressed', self, '_on_Button_pressed', [o.text])
		o.connect('pressed', $MenuSfx, 'play', ['select'])
		o.connect('focus_entered', $MenuSfx, 'play', ['focus'])
	for o in $Ops2.get_children():
		o.connect('pressed', self, '_on_Button_pressed', [o.text])
		o.connect('pressed', $MenuSfx, 'play', ['select'])
		o.connect('focus_entered', $MenuSfx, 'play', ['focus'])

func _ready():
	clear()
	$"Nums/0".grab_focus()

func update_result():
	$Result.text = line

func parse(text, to_float=true):
	var result = []
	var last = 0
	for i in range(text.length()):
		if text[i] in SYM.values():
			if text[i] != SYM[S_SQRT]:
				if to_float:
					result.append(float(text.substr(last, i-last)))
				else:
					result.append(text.substr(last, i-last))
			result.append(text[i])
			last = i+1
		elif i == text.length()-1:
			if to_float:
				result.append(float(text.substr(last, i+1-last)))
			else:
				result.append(text.substr(last, i+1-last))
	return result

func strip_edges(text:String):
	if text.length() > 0:
		if text[0] in STRIP_F:
			text = text.lstrip(text[0])
	if text.length() > 0:
		if text[-1] in STRIP_B:
			text = text.rstrip(text[-1])
	return text

func calc():
	var result = parse(line)
	while result.size() > 1:
		if SYM[S_SQRT] in result:
			var s = result.find(SYM[S_SQRT])
			if result.size()-1 > s:
				var res = sqrt(result[s+1])
				result[s] = res
				result.remove(s+1)
		elif SYM[S_POW] in result:
			var p = result.find(SYM[S_POW])
			if result.size()-1 > p and p != 0:
				var res = pow(result[p-1], result[p+1])
				result[p-1] = res
				result.remove(p+1)
				result.remove(p)
		elif SYM[S_PERCENT] in result:
			var p = result.find(SYM[S_PERCENT])
			if result.size()-1 > p and p != 0:
				var res = result[p+1]* (result[p-1]/100.0)
				result[p-1] = res
				result.remove(p+1)
				result.remove(p)
		elif SYM[S_MULT] in result:
			var x = result.find(SYM[S_MULT])
			if result.size()-1 > x and x != 0:
				var res = result[x-1]*result[x+1]
				result[x-1] = res
				result.remove(x+1)
				result.remove(x)
		elif SYM[S_DIV] in result:
			var d = result.find(SYM[S_DIV])
			if result.size()-1 > d and d != 0:
				if result[d+1] == 0:
					result = ['ERROR']
					break
				var res = result[d-1]/result[d+1]
				result[d-1] = res
				result.remove(d+1)
				result.remove(d)
		elif SYM[S_MIN] in result:
			var m = result.find(SYM[S_MIN])
			if result.size()-1 > m:
				if m != 0:
					var res = result[m-1]-result[m+1]
					result[m-1] = res
					result.remove(m+1)
					result.remove(m)
				else:
					result[0] = -result[m+1]
					result.remove(m+1)
		elif SYM[S_PLUS] in result:
			var p = result.find(SYM[S_PLUS])
			if result.size()-1 > p and p != 0:
				var res = result[p-1]+result[p+1]
				result[p-1] = res
				result.remove(p+1)
				result.remove(p)
	if not result.empty():
		line = str(result[0])
	update_result()

func clear():
	line = ''
	update_result()

func _on_Button_pressed(button):
	if line == 'ERROR':
		clear()
	if button == SYM[S_CLEAR]:
		clear()
	elif button in BASIC:
		if line.length() == 0:
			line += button
		elif not line[-1] in SYM.values():
			line += button
	elif button in NUMS:
		line += button
	elif button == '.':
		var list = parse(line, false)
		if list.size() > 0 and not '.' in list[-1]:
			line+='.'
	elif button in [SYM[S_POW], SYM[S_PERCENT]]:
		if line.length() > 0 and not line[-1] in SYM.values():
			line += button
	elif button == SYM[S_SQRT]:
		if line.length() == 0:
			line += button
		elif line.length() > 0 and not line[-1] in [SYM[S_SQRT]]:
			line += button
	elif button == '=' and line.length() != 0:
		line = strip_edges(line)
		calc()
	update_result()
