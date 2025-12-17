extends CharacterBody2D

enum Behaviors { IDLE, MOVE, WANDER, ADV }

var EmptyState = preload("res://Scenes/State/empty_state.tscn")
var IdleState = preload("res://Scenes/State/idle_state.tscn")
var PathState = preload("res://Scenes/State/path_state.tscn")
var WanderState = preload("res://Scenes/State/wander_state.tscn")

signal on_death(enemy)

@export var MaxHealth : float = 100
@export var CollisionDamage : float = 5
var health : float
var dying = false
var activated = false

@export var Behavior : Behaviors = Behaviors.IDLE
@export var Paths : Array
@export var EntrySpeed : float = 500
@export var MainSpeed : float = 200
@export var States : Array
var current_state

@export_range(-180, 180, 0.1, "radians_as_degrees") var firingAngle: float
@export var firingRotatingSpeed : float = 0
@export_range(-180, 180, 0.1, "radians_as_degrees") var rotationAngle: float

func _ready():
	health = MaxHealth
	$CollisionShape2D.disabled = true
	visible = false
	
	if Behavior == Behaviors.IDLE:
		var entryState = PathState.instantiate()
		entryState.move_speed = EntrySpeed
		if (Paths.size() > 0):
			entryState.patrol_path = NodePath('../' + String(Paths[0]))
		add_child(entryState)
		States.push_back(entryState.get_path())
			
		var mainState = IdleState.instantiate()

		for child in get_children():
			if child.script != null and child.script.resource_path == "res://addons/BulletUpHell/Nodes/BuHSpawnPoint.gd":
				mainState.FiringNodes.push_back(child.get_path())
				if firingAngle != 0:
					child.global_rotation = firingAngle + PI
				child.rotating_speed = firingRotatingSpeed
				if rotationAngle > 0:
					child.rotating_angle_limit = true
					child.rotating_angle = rotationAngle
					child.rotating_angle_default = firingAngle + PI
		add_child(mainState)
		States.push_back(mainState.get_path())
	elif Behavior == Behaviors.WANDER:
		var entryState = PathState.instantiate()
		entryState.move_speed = EntrySpeed
		if (Paths.size() > 0):
			entryState.patrol_path = NodePath('../' + String(Paths[0]))
		add_child(entryState)
		States.push_back(entryState.get_path())
			
		var mainState = WanderState.instantiate()
		for child in get_children():
			if child.script != null and child.script.resource_path == "res://addons/BulletUpHell/Nodes/BuHSpawnPoint.gd":
				mainState.FiringNodes.push_back(child.get_path())
				if firingAngle != 0:
					child.global_rotation = firingAngle + PI
				child.rotating_speed = firingRotatingSpeed
				if rotationAngle > 0:
					child.rotating_angle_limit = true
					child.rotating_angle = rotationAngle
					child.rotating_angle_default = firingAngle + PI
		add_child(mainState)
		States.push_back(mainState.get_path())
	elif Behavior == Behaviors.MOVE:
		var entryState = PathState.instantiate()
		if (Paths.size() > 0):
			entryState.patrol_path = NodePath('../' + String(Paths[0]))
		entryState.move_speed = EntrySpeed
		add_child(entryState)
		States.push_back(entryState.get_path())
		
		var mainState = PathState.instantiate()
		if (Paths.size() > 1):
			mainState.patrol_path = NodePath('../' + String(Paths[1]))
			mainState.loop = true
		mainState.move_speed = MainSpeed
		for child in get_children():
			if child.script != null and child.script.resource_path == "res://addons/BulletUpHell/Nodes/BuHSpawnPoint.gd":
				mainState.FiringNodes.push_back(child.get_path())
				if firingAngle != 0:
					child.global_rotation = firingAngle + PI
				child.rotating_speed = firingRotatingSpeed
				if rotationAngle > 0:
					child.rotating_angle_limit = true
					child.rotating_angle = rotationAngle
					child.rotating_angle_default = firingAngle + PI
		add_child(mainState)
		States.push_back(mainState.get_path())

func activate():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
	activated = true
	if(States.size() > 0):
		current_state = get_node(States[0])
		current_state.activate(self)
	
func take_damage(damage, direction):
	if dying:
		return
		
	health -= damage
	if health < 0:
		die()
	else:
		$DamageAnimation.play("Damage")
		if !$HitSFX.playing:
			var k = randi_range(-2, 2)
			var pitch = pow(2.0, k/12.0) 
			$HitSFX.pitch_scale = pitch
			$HitSFX.play()

func die():
	dying = true
	if current_state:
		current_state.deactivate()
	$CollisionShape2D.disabled = true
	$DamageAnimation.play("Death")
	var k = randi_range(-2, 2)
	var pitch = pow(2.0, k/12.0) 
	$DeathSFX.pitch_scale = pitch
	$DeathSFX.play()
	get_tree().call_group("EnemyDeath", "_on_enemy_death")
	on_death.emit(self)

func remove():
	queue_free()
	
func _physics_process(delta):
	if current_state:
		current_state._process_state(delta)
		if current_state.is_complete():
			current_state.deactivate()
			current_state.queue_free()
			States.pop_front()
			if(States.size() > 0):
				current_state = get_node(States[0])
				current_state.activate(self)
			else:
				current_state = null
