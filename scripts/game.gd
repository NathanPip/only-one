class_name Game
extends Node2D

signal on_ready

var spawner_groups: Array[SpawnerGroup] = []
var fired_projectiles: Array[Projectile] = []
var powerups_map: Dictionary[Globals.power_up_type, PowerUpRes] = {}
var projectiles_map: Dictionary[Globals.power_up_type, ProjectileResource] = {}

var projectiles: Array[Projectile] = []
var player: Player 
var proj_timer: Timer 
var powerup_timer: Timer 
var starting_spawn = Vector2(-100, -100)

@export var power_up_resources: Array[PowerUpRes] = []
@export var projectile_resources: Array[ProjectileResource] = []
@export var proj_wait_range: Vector2 = Vector2(.2, .8)
@export var powerup_wait_range: Vector2 = Vector2(15, 45)

func collision_check(proj: Projectile) -> bool:
	if proj.position.x-proj.size/2 < player.position.x + 24 && proj.position.x + proj.size/2 > player.position.x - 24 && proj.position.y - proj.size/2 < player.position.y + 24 && proj.position.y + proj.size/2 > player.position.y - 24:
		return true
	return false

func on_collision(proj: Projectile):
	if proj.type == Globals.projectile_type.BASIC_PROJECTILE:
		Globals.take_damage(1)
	elif proj.type == Globals.projectile_type.EX_PROJECTILE:
		Globals.take_damage(1)
	if powerups_map.has(proj.type):
		player.set_power_up(powerups_map[proj.type].inst)
		Globals.change_powerup.emit(proj.texture)

func kill_projectile(proj: Projectile, index: int):
	projectiles_map[proj.type].ready_projectiles.append(proj)
	fired_projectiles.remove_at(index)
	proj.fired = false
	proj.visible = false
	pass

func spawn_projectile(proj: Projectile):
	fired_projectiles.append(proj)
	proj.fired = true
	proj.visible = true

func choose_spawner() -> SpawnerGroup:
	var rand_spawn = randi_range(0, 3)
	var spawner = spawner_groups[rand_spawn]
	return spawner

func _on_proj_timeout():
	var spawner = choose_spawner()
	var proj_res = projectiles_map[Globals.projectile_type.BASIC_PROJECTILE] 
	var proj = proj_res.ready_projectiles.pop_front()
	if proj != null:
		spawner.prepare_projectile(proj, proj_res.speed_range)
		spawn_projectile(proj)
	var rand = randf_range(proj_wait_range.x, proj_wait_range.y)
	proj_timer.wait_time = rand

func _on_powerup_timeout():
	var spawner = choose_spawner()
	var keys = powerups_map.keys()
	var rand_power_up = randi_range(0, keys.size()-1)
	var power_up = powerups_map[keys[rand_power_up]]
	var speed_range = projectiles_map[power_up.projectile_type].speed_range
	var pup = projectiles_map[power_up.projectile_type].ready_projectiles.pop_front()
	print(pup)
	if pup != null:
		spawner.prepare_projectile(pup, speed_range)
		spawn_projectile(pup)
	var rand = randf_range(powerup_wait_range.x, powerup_wait_range.y)
	powerup_timer.wait_time = rand

func setup_projectiles(projectiles: Array[ProjectileResource]):
	for proj in projectiles:
		if projectiles_map.has(proj.type):
			print("multiple projectile resources present")
			get_tree().quit()
			return
		if proj.projectile_scene == null:
			print("no projectile scene present in projectile ", proj.type)
			get_tree().quit()
			return
		for i in range(proj.instantiation_count):
			var inst = proj.projectile_scene.instantiate() as Projectile
			if proj.additional_sprites.size() > 0:
				var tex = proj.additional_sprites[i % proj.additional_sprites.size()]
				inst.texture = tex
			inst.type = proj.type
			self.add_child(inst)
			inst.global_position = starting_spawn 
			proj.ready_projectiles.append(inst)
			projectiles.append(inst)
		projectiles_map[proj.type] = proj

func setup_powerups(powerups: Array[PowerUpRes]):
	for p in powerups:
		var inst = p.powerup.instantiate() as PowerUp
		inst.type = p.projectile_type
		p.inst = inst
		if powerups_map.has(p.projectile_type):
			print("double powerups exists")
			get_tree().quit()
			return
		self.add_child(inst)
		powerups_map[p.projectile_type] = p

func reset():
	for proj in fired_projectiles:
		proj.global_position = starting_spawn
		proj.fired = false
		projectiles_map[proj.type].ready_projectiles.append(proj)
	proj_timer.wait_time = 1
	powerup_timer.wait_time = randf_range(powerup_wait_range.x, powerup_wait_range.y)
	on_ready.emit()
	pass

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

	Globals.reset_game.connect(reset)
	setup_projectiles(projectile_resources)
	setup_powerups(power_up_resources)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var size = fired_projectiles.size()
	for i in range(size-1, -1, -1):
		var proj = fired_projectiles[i]
		if proj == null || !proj.fired:
			fired_projectiles.remove_at(i)
			continue
		proj._move(delta)
		if collision_check(proj) && !player.invulnerable:
			on_collision(proj)	
			kill_projectile(proj, i)
			continue
		if proj.position.x > 2000 || proj.position.x < -300 || proj.position.y > 2000 || proj.position.y < -300:
			kill_projectile(proj, i)
			continue
