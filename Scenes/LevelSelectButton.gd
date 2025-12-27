extends Button

@export var level_name = ''
@export var level : int
@export var image = ''

func _ready():
	var m = $"../../../../../../../.."
	if level > m.max_level:
		visible = false

func _on_pressed():
	get_tree().call_group("LevelSelectDisplay", "load_data", self)
	#$"../../../../../../../AcceptSFX".play()
	
	$"../../VBoxContainer/HBoxContainer/Continue".grab_focus()
	
	$"../../../../../TextureRect1".visible = false
	$"../../../../../TextureRect2".visible = false
	$"../../../../../TextureRect3".visible = false
	$"../../../../../TextureRect4".visible = false
	$"../../../../../TextureRect5".visible = false
	$"../../../../../TextureRect6".visible = false
			
	match level:
		1:
			$"../../../../../TextureRect1".visible = true
		2:
			$"../../../../../TextureRect2".visible = true
		3:
			$"../../../../../TextureRect3".visible = true
		4:
			$"../../../../../TextureRect4".visible = true
		5:
			$"../../../../../TextureRect5".visible = true
		6:
			$"../../../../../TextureRect6".visible = true
