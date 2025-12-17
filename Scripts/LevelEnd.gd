extends Area2D

func _on_area_2d_area_entered(area):
	exit()
	
func exit():
	get_tree().call_group("GameMain", "finish_level")
