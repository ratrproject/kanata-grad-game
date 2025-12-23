extends Node2D

enum State {Spawning, Activating, Despawning}
var current_state = State.Spawning

@export var max_speed : float = 800
@export var leave_speed : float = 600
@export var offscreen : bool = false

func _ready():
	if global_position.y > 540:
		position.y += 600
	else:
		position.y -= 600
	$AudioStreamPlayer2D.play()
		
	
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
		State.Activating:
			if offscreen:
				for child in get_children():
					if child.script != null and child.script.resource_path == "res://addons/BulletUpHell/Nodes/BuHSpawnPoint.gd":	
						child.global_position.x = -10
		State.Despawning:
			position.x -= leave_speed * delta
	
func activate():
	
	for child in get_children():
		if child.script != null and child.script.resource_path == "res://addons/BulletUpHell/Nodes/BuHSpawnPoint.gd":	
			child.activate()
	$Timer.start()
	current_state = State.Activating

func _on_timer_timeout():
	current_state = State.Despawning
	$DespawnTimer.start()
	var new_parent = get_parent().get_parent().get_parent()
	reparent(new_parent)
	
func despawn():
	queue_free()
