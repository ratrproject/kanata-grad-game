extends State

@export var move_speed = 100
@export var patrol_path : NodePath
var patrol_points
var patrol_index = 0

@export var loop = false

func activate(enty):
	super(enty)
	
	if patrol_path:
		var patrol_node = get_node(patrol_path)
		patrol_points = patrol_node.curve.get_baked_points()
		for i in range(patrol_points.size()):
			patrol_points[i] += patrol_node.global_position 
		
func _process_state(delta):
	if !is_active() or !patrol_path:
		return
	var target = patrol_points[patrol_index]
	if entity.global_position.distance_to(target) <= move_speed * delta:
		if patrol_index + 1 >= patrol_points.size() && !loop:
			state = STATUS.COMPLETE
		
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	entity.velocity = (target - entity.global_position).normalized() * move_speed
	entity.move_and_slide()
	pass
