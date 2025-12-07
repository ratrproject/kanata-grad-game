extends Node2D
class_name State

enum STATUS {INACTIVE,ACTIVE, COMPLETE}
var state = STATUS.INACTIVE

func is_active():
	return state == STATUS.ACTIVE

func activate():
	state = STATUS.ACTIVE

func is_complete():
	return state == STATUS.COMPLETE
	
func _process_state(entity, delta):
	pass
