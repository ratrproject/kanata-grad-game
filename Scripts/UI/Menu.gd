extends CanvasLayer

enum States { MAIN, PAUSE, FREEZE, END }
var stateStack : Array

@export var alt_image_path : String
@export var alt_level_complete : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	_changeState(States.MAIN)
	
	get_tree().call_group("Cursor", 'set_hidden')
	
	if alt_image_path:
		$EndMenu.change_texture(alt_image_path)
		
	if alt_level_complete:
		$EndMenu.alt_level_complete()
		
	
func _input(event):
	if Input.is_action_just_pressed ("Pause"):
		if stateStack[0] != States.END && stateStack[0] != States.PAUSE:
			_changeState(States.PAUSE)
			
func unpause():
	if stateStack[0] == States.PAUSE:
		return endState()
	return false
	
func endState():
	stateStack.pop_front()
	_updateState()
	return true
	
func _changeState(state):
	if stateStack.size() > 0 and state == stateStack[0]:
		return
		
	stateStack.push_front(state)
	_updateState()
	
	return true
	
func _updateState():
	var state = stateStack[0]
	
	match state:
		States.MAIN:
			get_tree().paused = false
			$PauseMenu.close()
			$EndMenu.close()
			get_tree().call_group("Cursor", 'set_hidden')
			
		States.FREEZE:
			get_tree().paused = true
			$PauseMenu.close()
			$EndMenu.close()
			if $Timer.is_paused():
				$Timer.set_paused(false)
			else:
				$Timer.start()
			get_tree().call_group("Cursor", 'set_hidden')
				
		States.PAUSE:
			get_tree().paused = true
			$PauseMenu.open()
			$EndMenu.close()
			get_tree().call_group("Cursor", 'set_menu')
			
		States.END:
			get_tree().paused = true
			$PauseMenu.close()
			$EndMenu.open()
			get_tree().call_group("Cursor", 'set_menu')


func freezeFrame():
	if stateStack[0] == States.MAIN:
		return _changeState(States.FREEZE)
	return false
	
func endFreezeFrame():
	if stateStack[0] == States.FREEZE:
		return endState()
	return false

func _on_enemy_death():
	freezeFrame()
