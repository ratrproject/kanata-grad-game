extends CharacterBody2D

@export var MaxHealth : float = 100
var health : float

@export var MaxTenshiPower : float = 100
var power : float

@export var speed = 400
var canFire : bool = true
var canRegen : bool = true

@export var TPPerShot : float = 2.5
@export var TPRegen : float = 67

var is_dead : bool = false

var deathDirection : Vector2
var deathSpeed = 1800
var deathSpinSpeed = 720

@export var master_bus_name := "Master"
@onready var _master_bus := AudioServer.get_bus_index(master_bus_name)
var volume = 1

var TowaState = preload("res://Scenes/Support/towa_support.tscn")
var current_support : Node2D = null

func _ready():
	health = MaxHealth
	power = MaxTenshiPower
	
func _physics_process(delta: float):
	if is_dead:
		$Sprite2D.rotate(deathSpinSpeed * delta)
		volume = lerpf(volume, 0, 4*delta)
		AudioServer.set_bus_volume_db(_master_bus, linear_to_db(volume))
		move_and_slide()
		return
		
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("Fire") and canFire and power >= TPPerShot:
		shoot()
	elif canRegen:
		power = min(power + TPRegen * delta, MaxTenshiPower)

	if Input.is_action_pressed("Support") and current_support == null:
		current_support = TowaState.instantiate()
		$SupportSpot.add_child(current_support)

func take_damage(damage, direction):
	health -= damage
	if health < 0:
		health = 0
		die(direction)
	else:
		$DamageAnimation.play("Damage")
		
		if !$HitSFX.playing:
			var k = randi_range(-2, 2)
			var pitch = pow(2.0, k/12.0) 
			$HitSFX.pitch_scale = pitch
			$HitSFX.play()

func die(direction):
	$AnimationPlayer.play("Death")
	is_dead = true
	volume = 1
	velocity = direction.normalized() * deathSpeed
	#$DeathAudioStreamPlayer2D.play()
	
func _die_die():
	visible = false
	get_tree().call_group("Main", "restart_level")	
	AudioServer.set_bus_volume_db(_master_bus, linear_to_db(1))
	
func shoot():
	canFire = false
	canRegen = false
	power -= TPPerShot
	$SpawnPoint.activate()
	$SpawnPoint.can_respawn = true
	$ShotTimer.start()
	$RegenTimer.start()
	
func can_fire():
	canFire = true

func can_regen():
	canRegen = true

func _on_area_2d_body_entered(body):
	take_damage(body.CollisionDamage, global_position - body.global_position)
