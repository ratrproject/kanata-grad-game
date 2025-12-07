extends Area2D

var id : int

func _on_tile_area_entered(area):
	if id != 0:
		get_tree().call_group("Background", "_shift_grid", self)
