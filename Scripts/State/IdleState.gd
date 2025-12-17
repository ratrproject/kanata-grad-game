extends State

@export var move_speed : float = 30
@export var move_range : float = 10

var startingPosition : Vector2
var dir = 1

func activate(enty):
	super(enty)	
	startingPosition = entity.global_position
		
func _process_state(delta):
	entity.position.y += move_speed * dir * delta
	if dir == 1:
		if entity.global_position.y > startingPosition.y + move_range:
			dir = -1
	else:
		if entity.global_position.y < startingPosition.y - move_range:
			dir = 1
