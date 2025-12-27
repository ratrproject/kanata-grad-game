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


@export var LunaSupportUnlocked = false
@export var WatameSupportUnlocked = false
@export var TowaSupportUnlocked = false
@export var CocoSupportUnlocked = false

var LunaSupport = preload("res://Scenes/Support/luna_support.tscn")
var WatameSupport = preload("res://Scenes/Support/watame_support.tscn")
var TowaSupport = preload("res://Scenes/Support/towa_support.tscn")
var CocoSupport = preload("res://Scenes/Support/coco_support.tscn")

var LunaSupportAvailable = true
var WatameSupportAvailable = true
var TowaSupportAvailable = true
var CocoSupportAvailable = true

var current_support : Node2D = null

var immune : bool = false

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
	
	#if Input.is_action_pressed("Fire") and canFire and power >= TPPerShot:
	#	shoot()
	#elif canRegen:
	#	power = min(power + TPRegen * delta, MaxTenshiPower)

	if Input.is_action_pressed("Support1") and LunaSupportUnlocked and LunaSupportAvailable:
		var current_support = LunaSupport.instantiate()
		LunaSupportAvailable = false
		$SupportSpot.add_child(current_support)
	if Input.is_action_pressed("Support2") and WatameSupportUnlocked and WatameSupportAvailable:
		var current_support = WatameSupport.instantiate()
		WatameSupportAvailable = false
		$SupportSpot.add_child(current_support)
	if Input.is_action_pressed("Support3") and TowaSupportUnlocked and TowaSupportAvailable:
		var current_support = TowaSupport.instantiate()
		TowaSupportAvailable = false
		$SupportSpot.add_child(current_support)
	if Input.is_action_pressed("Support4") and CocoSupportUnlocked and CocoSupportAvailable:
		var current_support = CocoSupport.instantiate()
		CocoSupportAvailable = false
		$SupportSpot.add_child(current_support)

func take_damage(damage, direction):
	if !immune:
		health -= damage
		if health < 0:
			health = 0
			die(direction)
		else:
			$DamageAnimation.play("Damage")
			immune = true
			
			if !$HitSFX.playing:
				var k = randi_range(-2, 2)
				var pitch = pow(2.0, k/12.0) 
				$HitSFX.pitch_scale = pitch
				$HitSFX.play()
			
func end_damage():
	immune = false

func die(direction):
	$AnimationPlayer.play("Death")
	$DeathSFX.play()
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

func unlockLuna():
	LunaSupportUnlocked = true
	
func unlockWatame():
	WatameSupportUnlocked = true
	
func unlockTowa():
	TowaSupportUnlocked = true
	
func unlockCoco():
	CocoSupportUnlocked = true
