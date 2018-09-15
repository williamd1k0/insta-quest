extends Control

func _ready():
	$MainMenu.menu_focus()

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		kill_app()

func _notification(what):
	if what == SceneTree.NOTIFICATION_WM_GO_BACK_REQUEST:
		kill_app()

func kill_app():
	$MenuSfx.play("back")
	if $App.get_child_count() > 0:
		$App.get_child(0).queue_free()


func _on_MainMenu_app_run(app):
	app.release_focus()
	$AppSplash.splash(
		app.app_name,
		app.icon_16x16,
		app.color,
		app.rect_global_position+app.rect_size/2.0
	)
	yield($AppSplash, 'splash')
	$MainMenu.hide()
	var app_node = load(app.app_scene).instance()
	app_node.connect('tree_exited', self, '_on_App_exit_tree')
	$App.add_child(app_node)

func _on_App_exit_tree():
	$MainMenu.show()
	$MainMenu.menu_focus()
