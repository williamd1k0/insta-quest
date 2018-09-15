extends Control

func _ready():
	$MainMenu/Dock/Apps/InstaE.grab_focus()
	for app in $MainMenu/Dock/Apps.get_children():
		app.connect('pressed', self, '_on_App_pressed', [app])
	for app in $MainMenu/Folder.get_children():
		app.connect('pressed', self, '_on_App_pressed', [app])

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		if $App.get_child_count() > 0:
			$App.get_child(0).queue_free()
			$MainMenu/Dock/Apps/InstaE.grab_focus()

func _on_App_pressed(app):
	app.release_focus()
	$AppSplash.splash(
		app.app_name,
		app.icon_16x16,
		app.color,
		app.rect_global_position+app.rect_size/2.0
	)
	yield($AppSplash, 'splash')
	$App.add_child(load(app.app_scene).instance())
