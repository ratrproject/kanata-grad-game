extends Button

@export var level_name = ''
@export var level : int
@export var image = ''

func _ready():
	var m = $"../../../../../../../../../.."
	if level > m.max_level:
		visible = false

func _on_pressed():
	get_tree().call_group("LevelSelectDisplay", "load_data", self)
	#$"../../../../../../../AcceptSFX".play()
	
	$"../../../VBoxContainer/HBoxContainer/Continue".grab_focus()
