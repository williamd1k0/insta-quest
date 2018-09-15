extends Node

const SAVE = 'user://マジ.卍'
const PASS = '探60ec9d35db103d59bea7342ea7868b861491f00c探'
var F = File.new()
var data = {}


func _ready():
	load_data()

func load_data():
	if F.file_exists(SAVE):
		if F.open_encrypted_with_pass(SAVE, File.READ, PASS) == OK:
			data = F.get_var()
			F.close()
		else:
			Directory.new().remove(SAVE)
			save_data()
	else:
		save_data()

func save_data():
	if F.open_encrypted_with_pass(SAVE, File.WRITE, PASS) == OK:
		F.store_var(data)
		F.close()
