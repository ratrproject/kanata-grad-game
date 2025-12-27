extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	var viewport : Viewport = get_viewport()
	viewport.gui_focus_changed.connect(_gui_focus_change)
	
	var buttons = $MarginContainer/VBoxContainer.get_children()
	buttons = buttons.filter(func(element): return element.visible and !(element is Label))
	for i in buttons.size():
		var above = (i-1) % buttons.size()
		var below = (i+1) % buttons.size()
		
		buttons[i].focus_neighbor_top = buttons[above].get_path()
		buttons[i].focus_neighbor_bottom = buttons[below].get_path()
	
func change_texture(path):
	var new_texture = load(path)
	$TextureRect3.texture = new_texture
	
func alt_level_complete():
	var new_texture = load("res://Sprites/UI/Menu/LevelCompleteAlt.png")
	$TextureRect2.texture = new_texture
	
func update_time(time):
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	$MarginContainer/VBoxContainer/VBoxContainer/Label3.text = "Clear Time: %02d:%02d" % [minutes, seconds]
			

func open():
	$TextureRect2.visible = false
	$TextureRect3.visible = false
	$MarginContainer.visible = false
	if visible == false:
		visible = true
		
	$AnimationPlayer.play("Open")
	$MarginContainer/VBoxContainer/Button2.grab_focus()
	get_tree().call_group("Main", "_on_victory")
	
func close():
	if visible == true:
		visible = false

func _on_quit_pressed():
	get_tree().call_group("Main", "exit_level")

func _on_restart_button_pressed():
	get_tree().call_group("Main", "restart_level")

func _on_next_level_button_pressed():
	get_tree().call_group("Main", "next_level")

func _gui_focus_change(node : Control):
	if (Input.is_action_just_pressed("ui_down") or \
		Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_right") or \
		Input.is_action_just_pressed("ui_up")) and \
	 	!$BlipSFX.playing:
			
		$BlipSFX.pitch_scale = randf_range(0.9,1.1)
		$BlipSFX.play()
	
	if Input.is_action_just_released("ui_accept") or \
		Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_right") or \
		Input.is_action_just_pressed("ui_up") or \
		Input.is_action_just_pressed("ui_down"):
		
		get_tree().call_group("Cursor", 'move_position', node.get_global_position() + Vector2(10,10))

func _on_audio_stream_player_2d_4_finished():
	pass
