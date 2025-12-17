extends VBoxContainer

var selected_level = ''
var selected_level_name = ''

#const Level1Texture = preload("res://Images/Levels/level_1.png")
#const Level2Texture = preload("res://Images/Levels/level_2.png")
#const Level3Texture = preload("res://Images/Levels/level_3.png")
#const Level4Texture = preload("res://Images/Levels/level_4.png")
#const Level5Texture = preload("res://Images/Levels/level_5.png")

func _ready():
	load_data($"../ScrollContainer/VBoxContainer2/Button")

func load_data(btn):
	#@export var image = ''
	selected_level = btn.level
	selected_level_name = btn.level_name
	
	$Label.text = selected_level_name
	
	var best_times = $"../../../../../../../..".best_times
	if selected_level > best_times.size():
		$HBoxContainer2/Time.text = '--:--'
	else:
		var time = best_times[selected_level-1]
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		$HBoxContainer2/Time.text = "%02d:%02d" % [minutes, seconds]
	
	#match selected_level:
	#1:	
	#	$TextureRect2/TextureRect.texture = Level1Texture
	#2:
	#	$TextureRect2/TextureRect.texture = Level2Texture
	#3:
	#	$TextureRect2/TextureRect.texture = Level3Texture
	#4:
	#	$TextureRect2/TextureRect.texture = Level4Texture
	#_:
	#	$TextureRect2/TextureRect.texture = Level5Texture
	
func _on_pressed():
	get_tree().call_group("Main", "load_level", selected_level)
