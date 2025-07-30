class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var starting_position: Vector2 = Vector2(601, 351)
@export var damage_inv_time: float = 1
@export var size = 48
var timer: Timer
var sprite: Sprite2D
var blood_particle: CPUParticles2D
var health_particle: CPUParticles2D
var current_power_up: PowerUp
var power_up_timer: float = 0:
	set(val):
		if val <= 0:
			power_up_active = false
			if current_power_up == null:
				return
			current_power_up._deactivate(self)
			current_power_up = null
			Globals.change_powerup.emit(null)
			return
		power_up_timer = val
	get:
		return power_up_timer 
var power_up_active: bool = false

@export var invulnerable = false

func play_damage_anim(amt: float):
	sprite.material.set_shader_parameter("damage_amt", amt*.4)

func play_heal_anim(amt: float):
	sprite.material.set_shader_parameter("heal_amt", amt*.4)

func inv_timeout():
	invulnerable = false
	blood_particle.emitting = false
	timer.wait_time = damage_inv_time

func heal():
	health_particle.restart()
	health_particle.emitting = true

func take_damage():
	invulnerable = true
	blood_particle.restart()
	blood_particle.emitting = true
	timer.start()
	pass

func set_power_up(power_up: PowerUp):
	current_power_up = power_up
	power_up_timer = power_up.duration

func get_input():
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * speed 
	else:
		velocity = Vector2.ZERO

func reset():
	position = starting_position
	power_up_active = false 
	current_power_up = null 
	power_up_timer = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if current_power_up != null && !power_up_active:
			current_power_up._activate(self)
			power_up_active = true

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func _ready() -> void:
	position = starting_position
	timer = get_node("Damage_Timer")
	sprite = get_node("Sprite2D")
	blood_particle = get_node("Blood_Particle")
	health_particle = get_node("Health_Particles")
	timer.wait_time = damage_inv_time
	timer.timeout.connect(inv_timeout)
	Globals.reset_game.connect(reset)
	Globals.damage_taken.connect(take_damage)
	Globals.damage_anim_playing.connect(play_damage_anim)
	Globals.healed.connect(heal)

func _process(delta: float) -> void:
	if power_up_active:
		power_up_timer -= delta
