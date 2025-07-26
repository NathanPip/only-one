class_name Game
extends Node2D

const projectile_scene = preload("res://scenes/projectile.tscn")
const invulnerable_powerup_scene = preload("res://scenes/invulnerable_power_up.tscn")

var spawner_groups: Array[SpawnerGroup] = []
var ready_projectiles: Array[Projectile] = []
var ready_powerup_projectiles_map: Dictionary = {}

var projectiles: Array[Projectile] = []
var player: Player 
var proj_timer: Timer 
var powerup_timer: Timer 
var starting_spawn = Vector2(-100, -100)

@export var power_up_resources: Array[PowerUpRes]
@export var proj_wait_range: Vector2 = Vector2(.2, .8)
@export var powerup_wait_range: Vector2 = Vector2(15, 45)
@export var projectile_count: int = 100
@export var powerup_count: int = 3

@export var projectile_speed_range: Vector2 = Vector2(100, 200)
@export var power_up_speed_range: Vector2 = Vector2(100, 200)

func collision_check(proj: Projectile) -> bool:
	if proj.position.x-proj.size/2 < player.position.x + 24 && proj.position.x + proj.size/2 > player.position.x - 24 && proj.position.y - proj.size/2 < player.position.y + 24 && proj.position.y + proj.size/2 > player.position.y - 24:
		return true
	return false

func kill_projectile(proj: Projectile):
	if proj is PowerUpProjectile:
		ready_powerup_projectiles_map[proj.power_up.power_up_type].ready_projectiles.append(proj)
	else:
		ready_projectiles.append(proj)
	proj.fired = false
	proj.visible = false
	pass

func spawn_projectile(proj: Projectile):
	proj.fired = true
	proj.visible = true

func choose_spawner() -> SpawnerGroup:
	var rand_spawn = randi_range(0, 3)
	var spawner = spawner_groups[rand_spawn]
	return spawner

func _on_proj_timeout():
	var spawner = choose_spawner()
	var proj = ready_projectiles.pop_front()
	if proj != null:
		spawner.prepare_projectile(proj, projectile_speed_range)
		spawn_projectile(proj)
	var rand = randf_range(proj_wait_range.x, proj_wait_range.y)
	proj_timer.wait_time = rand

func _on_powerup_timeout():
	var spawner = choose_spawner()
	var keys = ready_powerup_projectiles_map.keys()
	var rand_power_up = randi_range(0, keys.size()-1)
	var ready_powerups = ready_powerup_projectiles_map[keys[rand_power_up]]
	print(ready_powerups)
	var pup = ready_powerups.ready_projectiles.pop_front()
	print(pup)
	if pup != null:
		spawner.prepare_projectile(pup, power_up_speed_range)
		spawn_projectile(pup)
	var rand = randf_range(powerup_wait_range.x, powerup_wait_range.y)
	powerup_timer.wait_time = rand

func instantiate_projectiles(count: int, list: Array[Projectile], proj_scene: PackedScene):
	for i in range(count):
		var proj = proj_scene.instantiate()
		self.add_child.call_deferred(proj)
		proj.global_position = starting_spawn 
		list.append(proj)	
		projectiles.append(proj)

func setup_powerups(powerups: Array[PowerUpRes]):
	for p in powerups:
		var inst = p.powerup.instantiate()
		if ready_powerup_projectiles_map.has(inst.power_up_type):
			print("double powerups exists")
			get_tree().quit()
			return
		self.add_child(inst)
		for i in range(powerup_count):
			var p_inst = p.projectile.instantiate() as PowerUpProjectile
			p_inst.power_up = inst
			self.add_child(p_inst)
			p.ready_projectiles.append(p_inst)
			projectiles.append(p_inst)
		ready_powerup_projectiles_map[inst.power_up_type] = p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	proj_timer = get_node("Projectile_Timer")
	powerup_timer = get_node("Powerup_Timer")
	proj_timer.timeout.connect(_on_proj_timeout)
	powerup_timer.timeout.connect(_on_powerup_timeout)
	powerup_timer.wait_time = randf_range(powerup_wait_range.x, powerup_wait_range.y)
	player = self.get_node("Player")
	if player == null:
		print("no player found")
		get_tree().quit()

	for child in get_children():
		if child is SpawnerGroup:
			spawner_groups.append(child)

	instantiate_projectiles(projectile_count, ready_projectiles, projectile_scene)
	setup_powerups(power_up_resources)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(projectiles.size()):
		var proj = projectiles[i]
		if proj == null || !proj.fired:
			continue
		proj._move(delta)
		if collision_check(proj) && !player.invulnerable:
			proj._on_impact(player)
			kill_projectile(proj)
		if proj.position.x > 2000 || proj.position.x < -300 || proj.position.y > 2000 || proj.position.y < -300:
			kill_projectile(proj)
