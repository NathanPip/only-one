class_name Ex
extends Node2D

enum ExState {ATTACKING, TRAVELING, WAITING}
enum Attacks {BASIC}
@export var current_attack: Attacks = Attacks.BASIC
@export var current_state: ExState = ExState.TRAVELING
@export var border: ExBorder
@export var speed: float = 100
@export var waiting_range: Vector2 = Vector2(5, 10)
@export var attack_range: Vector2 = Vector2(2, 5)
@export var basic_attack_fire_rate: float = 10
var attack_point: Vector2 = Vector2(0,0)
var game_node: Game
var player_node: Player
var timer: Timer
var current_attack_time: float = 0
var next_attack_time: float = 0

func pick_point() -> Vector2:
	var side = randi_range(0,3)
	var pos = border.global_position
	if side == 0:
		return Vector2(pos.x, pos.y + randf_range(0, border.size.y))
	elif side == 1:
		return Vector2(pos.x + border.size.x, pos.y + randf_range(0, border.size.y))
	elif side == 2:
		return Vector2(pos.x + randf_range(0, border.size.x), pos.y)
	else:
		return Vector2(pos.x + randf_range(0, border.size.x), pos.y + border.size.y)

func wait_for_attack():
	current_state = ExState.WAITING
	timer.wait_time = randf_range(waiting_range.x, waiting_range.y)
	timer.start()
	pass

func on_timer_end():
	if current_state == ExState.WAITING:
		current_state = ExState.ATTACKING
		timer.wait_time = randf_range(attack_range.x, attack_range.y)
		timer.start()
	elif current_state == ExState.ATTACKING:
		attack_point = pick_point()
		current_state = ExState.TRAVELING

func basic_attack(delta: float):
	current_attack_time += delta
	if current_attack_time >= next_attack_time:
		next_attack_time += 1/basic_attack_fire_rate
		var proj = game_node.ready_ex_projectiles.pop_front()
		proj.direction = self.position.direction_to(player_node.position)
		proj.position = self.position
		game_node.spawn_projectile(proj)
	pass

func attack(delta: float):
	print("attacking")
	if current_attack == Attacks.BASIC:
		basic_attack(delta)
	pass

func choose_attack():
	var rand = randi_range(0, Attacks.size()-1)
	current_attack = Attacks.keys()[rand]
	pass

func travel(delta: float):
	self.position = self.position.move_toward(attack_point, delta*speed)
	if self.position.distance_to(attack_point) <= 1:
		self.position = attack_point
		wait_for_attack()

func reset():
	self.position = pick_point()
	pass

func _ready() -> void:
	if border == null:
		print("no ex border assigned")
		get_tree().quit()
	
	timer = get_node("Timer")
	timer.timeout.connect(on_timer_end)
	game_node = get_tree().get_root().get_node("Node2D").get_node("Game")
	player_node = game_node.get_node("Player")
	attack_point = pick_point()
	Globals.reset_game.connect(reset)
	pass

func _process(delta: float) -> void:
	print(current_state)
	if current_state == ExState.TRAVELING:
		travel(delta)
	if current_state == ExState.ATTACKING:
		attack(delta)
	pass
