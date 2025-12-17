extends Node2D

enum State {Spawning, Activating, Despawning}
var current_state = State.Spawning

@export var max_speed : float = 800
@export var leave_speed : float = 600

func _ready():
	if global_position.y > 540:
		position.y += 600
	else:
		position.y -= 600
		
	
func _physics_process(delta):
	match current_state:
		State.Spawning:
			var speed = max_speed * delta
			var disp : Vector2 = get_parent().global_position - global_position
			
			if disp.length() <= speed:
				position = Vector2(0,0)
				activate()
			else:
				var direction  = disp.normalized()
				position += direction * speed
		State.Despawning:
			position.x -= leave_speed * delta
	
func activate():
	$SpawnPoint.activate()
	$Timer.start()
	current_state = State.Activating

func _on_timer_timeout():
	current_state = State.Despawning
	$DespawnTimer.start()
	var new_parent = get_parent().get_parent().get_parent()
	reparent(new_parent)
	
func despawn():
	queue_free()
