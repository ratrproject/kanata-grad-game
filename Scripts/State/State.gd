extends Node2D
class_name State

var entity : Node2D

enum STATUS {INACTIVE,ACTIVE, COMPLETE}
var state = STATUS.INACTIVE

@export var FiringNodes : Array

func is_active():
	return state == STATUS.ACTIVE

func activate(enty):
	state = STATUS.ACTIVE
	entity = enty
	for fnode in FiringNodes:
		get_node(fnode).activate()

func deactivate():
	for fnode in FiringNodes:
		get_node(fnode).active = false
	
func is_complete():
	return state == STATUS.COMPLETE
	
func _process_state(delta):
	pass
