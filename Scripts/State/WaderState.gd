extends State

@export var move_speed : float = 100
@export var move_range : float = 100
var home : Vector2
var target : Vector2

func activate(enty):
	super(enty)	
	home = global_position
	change_target()
		
func _process_state(delta):
	var displacement = target - entity.global_position
	var velocity =  displacement.normalized() * move_speed * delta

	if(velocity.length() < displacement.length()):
		entity.position += velocity
	else:
		entity.global_position = target
		change_target()

func change_target():
	target = home + randv_circle(0, move_range)

func randv_circle(min_radius := 1.0, max_radius := 1.0) -> Vector2:
	var r2_max := max_radius * max_radius
	var r2_min := min_radius * min_radius
	var r := sqrt(randf() * (r2_max - r2_min) + r2_min)
	var t := randf() * TAU
	return Vector2(r, 0).rotated(t)
