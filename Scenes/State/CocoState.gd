extends State

@export var move_speed : float = 100
@export var move_range : float = 100
var home : Vector2
var target : Vector2

@export var SpawnPoints : Array
var occupiedPoints : Array
const CocoFan = preload("res://Scenes/Enemy/coco_fan.tscn")

func activate(enty):
	super(enty)	
	
	for point in SpawnPoints:
		occupiedPoints.push_back(null)
	
	home = global_position
	change_target()
	spawn()
		
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
	
func spawn():
	var empty_points : Array
	
	for x in range(occupiedPoints.size()):
		if occupiedPoints[x] == null:
			empty_points.push_back(x)
			
	var iterations = 0
	var healthPercent = entity.health / entity.MaxHealth
	if healthPercent > 0.75:
		iterations = 1
	elif healthPercent > 0.4:
		iterations = 2
	elif healthPercent > 0:
		iterations = 3
		
	iterations -= (occupiedPoints.size() - empty_points.size())
	
	if iterations > 0:
		var nodeLength = empty_points.size()
		var randIdx = randi_range(0, nodeLength - 1)
		var idx = empty_points[randIdx]
		
		var fan = CocoFan.instantiate()
		#fan.Behavior = entity.Behaviors.IDLE
		fan.Paths.push_back(SpawnPoints[idx].slice(1))
		fan.global_position = get_node(SpawnPoints[idx]).global_position
		entity.get_parent().add_child(fan)
		occupiedPoints[idx] = fan
		empty_points.remove_at(randIdx)
		fan.activate()
		$"../../..".register_enemy(fan)
	$Timer.start()
