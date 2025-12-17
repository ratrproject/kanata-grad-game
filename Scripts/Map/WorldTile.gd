extends Area2D

enum BG_POSITION {FRONT, MID, BACK}
@export var bg_position : BG_POSITION

var id : int

func _on_tile_area_entered(area):
	if id != 0:
		match bg_position:
			BG_POSITION.FRONT:
				get_tree().call_group("Background", "_shift_front", self)
			BG_POSITION.MID:
				get_tree().call_group("Background", "_shift_mid", self)
			BG_POSITION.BACK:
				get_tree().call_group("Background", "_shift_back", self)
