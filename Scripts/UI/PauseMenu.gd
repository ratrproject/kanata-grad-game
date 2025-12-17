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
	
	
func _input(event):
	if Input.is_action_just_pressed ("Pause") || Input.is_action_just_pressed ("ui_cancel") :
		_on_back_button_pressed()
		
func open():
	if visible == false:
		visible = true
		
	$MarginContainer/VBoxContainer.visible = true
	$MarginContainer/VBoxContainer2.visible = false
	$MarginContainer/VBoxContainer/Button2.grab_focus()
	
func close():
	if visible == true:
		visible = false

func _on_quit_pressed():
	$AcceptSFX.play()
	get_tree().call_group("Main", "exit_level")

func _on_back_button_pressed():
	$BackSFX.play()
	$"..".unpause()

func _on_resume_button_pressed():
	$AcceptSFX.play()
	$"..".unpause()

func _on_restart_button_pressed():
	$AcceptSFX.play()
	get_tree().call_group("Main", "restart_level")

func _on_settings_on_pressed():
	$MarginContainer/VBoxContainer.visible = false
	$MarginContainer/VBoxContainer2.visible = true
	$AcceptSFX.play()

func _on_settings_on_back_pressed():
	$MarginContainer/VBoxContainer.visible = true
	$MarginContainer/VBoxContainer2.visible = false
	$BackSFX.play()
	
	
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
