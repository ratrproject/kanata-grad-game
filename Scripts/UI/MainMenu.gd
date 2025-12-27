extends Control

# Called when the node enters the scene tree for the first time.
func _ready():		
	$Main.visible = true
	$Setttings.visible = false
	$Credits.visible = false
	$LevelSelect.visible = false
	
	$Main/MarginContainer/VBoxContainer/Start.grab_focus()
	
	if OS.has_feature('web'):
		$Main/MarginContainer/VBoxContainer/Quit.visible = false
	
	var buttons = $Main/MarginContainer/VBoxContainer.get_children()
	
	buttons = buttons.filter(func(element): return element.visible && !(element is Label))
	for i in buttons.size():
		var above = (i-1) % buttons.size()
		var below = (i+1) % buttons.size()
		
		buttons[i].focus_neighbor_top = buttons[above].get_path()
		buttons[i].focus_neighbor_bottom = buttons[below].get_path()
			
	var levels = $LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2.get_children()
	levels = levels.filter(func(element): return element.visible && !(element is Label))
	levels.push_back($LevelSelect/MarginContainer/VBoxContainer/Button)
	for i in levels.size():
		var above = (i-1) % levels.size()
		var below = (i+1) % levels.size()
		
		levels[i].focus_neighbor_top = levels[above].get_path()
		levels[i].focus_neighbor_bottom = levels[below].get_path()
		
		levels[i].focus_neighbor_left = $LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Continue.get_path()
		levels[i].focus_neighbor_right = $LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Continue.get_path()
					
	var viewport : Viewport = get_viewport()
	viewport.gui_focus_changed.connect(_gui_focus_change)
	
	get_tree().call_group("Cursor", 'set_menu')

func _on_quit_pressed():
	get_tree().quit()

func _input(event):
	if $LevelSelect.visible: 
		if Input.is_action_just_pressed ("ui_cancel") :
			_on_level_select_back_pressed()
	if $Setttings.visible: 
		if Input.is_action_just_pressed ("ui_cancel") :
			_on_settings_back_pressed()
	if $Credits.visible: 
		if Input.is_action_just_pressed ("ui_cancel") :
			_on_credits_back_pressed()
	
func _on_level_select_pressed():
	$AnimationPlayer.play("LevelSelectOpen")
	
	$LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Button.grab_focus()
	
	$AcceptSFX.play()
		
func _on_settings_pressed():
	$AnimationPlayer.play("SettingsOpen")
	$Setttings/VBoxContainer/Settings._grab_focus()
	
	$AcceptSFX.play()
		
func _on_credits_pressed():
	$AnimationPlayer.play("CreditsOpen")
	
	$Credits/MarginContainer/VBoxContainer/Back.grab_focus()
	
	$AcceptSFX.play()
	
func open_credits():
	$Main.visible = false
	$Setttings.visible = false
	$Credits.visible = true
	$LevelSelect.visible = false
	
	#$VBoxContainer/Credits/VBoxContainer/Back.grab_focus()

func _on_level_select_back_pressed():
	$AnimationPlayer.play("LevelSelectClose")
	$Main/MarginContainer/VBoxContainer/Start.grab_focus()
	
	$BackSFX.play()

func _on_settings_back_pressed():
	$AnimationPlayer.play("SettingsClose")
	$Main/MarginContainer/VBoxContainer/Settings.grab_focus()
	
	$BackSFX.play()
	
func _on_credits_back_pressed():
	$AnimationPlayer.play("CreditsClose")
	$Main/MarginContainer/VBoxContainer/Credits.grab_focus()
	
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
		
	if node != $LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Continue:
		$LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Continue.focus_neighbor_right = node.get_path()
		$LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Continue.focus_neighbor_left = node.get_path()
