class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var starting_position: Vector2 = Vector2(601, 351)
var current_power_up: PowerUp
var power_up_timer: float = 0:
	set(val):
		if val <= 0:
			power_up_active = false
			if current_power_up == null:
				return
			current_power_up._deactivate(self)
			current_power_up = null
			return
		power_up_timer = val
	get:
		return power_up_timer 
var power_up_active: bool = false

@export var invulnerable: bool:
	set(value):
		invulnerable = value
		var color = self.modulate
		if value:
			self.modulate = Color(color.a, color.g, color.b, .5)
		else:
			self.modulate = Color(color.a, color.g, color.b, 1)
	get:
		return invulnerable

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
	Globals.reset_game.connect(reset)

func _process(delta: float) -> void:
	if power_up_active:
		power_up_timer -= delta
