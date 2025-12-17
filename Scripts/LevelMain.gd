extends Node2D

var elapsed_time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta

func finish_level():
	get_tree().call_group("EndMenu", "update_time", elapsed_time)
	$CanvasLayer._changeState($CanvasLayer.States.END)
