extends Control

signal app_run(app)

func _enter_tree():
	init_ui()

func init_ui():
	for app in $Dock/Apps.get_children():
		app.connect('pressed', self, 'emit_signal', ['app_run', app])
	for app in $Folder.get_children():
		app.connect('pressed', self, 'emit_signal', ['app_run', app])

func menu_focus():
	$Dock/Apps/InstaE.grab_focus()

