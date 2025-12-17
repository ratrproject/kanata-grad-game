extends Node2D

var activated = false

func _on_area_2d_area_entered(area):
	if !activated:
		activate_checkpoint()

func activate_checkpoint():
	activated = true
	get_tree().call_group("Background", "hit_checkpoint")
	for enemy in $Enemies.get_children():
		enemy.on_death.connect(_on_enemy_death)
		enemy.activate()

func _on_enemy_death(enemy):
	if $Enemies.get_children().filter(func(e): return !e.dying ).size() == 0:
		get_tree().call_group("Background", "cleared_checkpoint")
