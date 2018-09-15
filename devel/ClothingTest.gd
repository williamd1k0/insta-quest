extends "res://game/gameplay/minigames/MiniGameBase.gd"

const DESL = 32

var color = Vector2(0,0)
var desired_color
var frame_number = 0

func _ready():
	._ready()
	choose_goal()
	
	pass

func _process(delta):
	
	camera_move()
	
	pass

func take_input():
	if color == desired_color:
		good_take = true
	.take_input()

func camera_move():
	
	if Input.is_action_just_pressed("ui_down"):
		if $Sprite.position.y > -52:
			$Sprite.position.y -= DESL
			color.y += 1
	elif Input.is_action_just_pressed("ui_up"):
		if $Sprite.position.y < 12:
			$Sprite.position.y += DESL
			color.y -= 1
	
	if Input.is_action_just_pressed("ui_right"):
		if $Sprite.position.x > -47:
			$Sprite.position.x -= DESL
			color.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		if $Sprite.position.x < 17:
			$Sprite.position.x += DESL
			color.x -= 1
	
	# Os valores do vetor color estão somando mais do que deveriam
	
	pass

func choose_goal():
		frame_number = 0
		desired_color = Vector2(int((rand_range(-2,2))),int((rand_range(-2,2))))
		
		if desired_color.y == 0:
			frame_number += 3
		elif desired_color.y == 1:
			frame_number += 6
		
		if desired_color.x == 0:
			frame_number += 1
		elif desired_color.x == 1:
			frame_number += 2
		
		$Names.set_frame(frame_number)