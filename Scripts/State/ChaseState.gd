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
		if $Timer.is_stopped():
			$Timer.start()

func change_target():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size():
		target = players[0].global_position

func _on_timer_timeout():
	change_target()
