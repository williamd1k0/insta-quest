tool
extends TextureButton

export(Texture) var icon_8x8
export(Texture) var icon_16x16
export(String) var app_name
export(Color) var color
export(String, FILE, '*.tscn') var app_scene

func _draw():
	if rect_size == Vector2(8, 8):
		draw_texture(icon_8x8, Vector2())
	else:
		draw_texture(icon_16x16, Vector2())
