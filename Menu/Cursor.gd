extends Node2D

var gun_cursor = load("res://Images/cursor.png")
var menu_cursor = load("res://Images/menu_cursor.png")

var mouse_locked = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_locked = false
		
func set_aim():
	$Sprite2D.visible = true
	$Sprite2D.texture = gun_cursor
	$Sprite2D.offset = Vector2(0,0)
	
func set_menu():
	$Sprite2D.visible = true
	$Sprite2D.texture = menu_cursor
	$Sprite2D.offset = Vector2(16,16)
	
func set_hidden():
	$Sprite2D.visible = false

func move_position(new_pos : Vector2):
	global_position = new_pos
	mouse_locked = true
	
func _process(delta):
	if !mouse_locked:
		global_position = get_global_mouse_position()
