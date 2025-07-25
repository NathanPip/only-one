class_name SpawnerGroup
extends Node2D

const projectile_scene = preload("res://scenes/projectile.tscn")

@export var projectile_count: int = 20
var spawners: Array[Spawner] = []
var ready_projectiles: Array[Projectile] = []
var projectiles: Array[Projectile] = []
var removables: Array[int] = []
var player: Player 

func collision_check(proj: Projectile) -> bool:
	if proj.position.x-proj.size/2 < player.position.x + 24 && proj.position.x + proj.size/2 > player.position.x - 24 && proj.position.y - proj.size/2 < player.position.y + 24 && proj.position.y + proj.size/2 > player.position.y - 24:
		return true
	return false

func fire_projectile():
	var rand = randi_range(0, spawners.size()-1)
	var spawner = spawners[rand]
	var proj = ready_projectiles.pop_front()
	proj.speed = randf_range(100, 150)
	if proj == null:
		print("no projectile")
		return
	var dir = spawner.shoot_direction.rotated(spawner.global_rotation)	
	proj.direction = dir
	proj.global_position = spawner.global_position
	spawn_projectile(proj)


func kill_projectile(proj: Projectile):
	ready_projectiles.append(proj)
	proj.fired = false
	proj.visible = false
	pass

func spawn_projectile(proj: Projectile):
	proj.fired = true
	proj.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_node = get_tree().get_root().get_node("Game")
	player = game_node.get_node("Player")
	if player == null:
		print("no player found")
		get_tree().quit()
	for child in get_children():
		if child is Spawner:
			spawners.append(child)
	var starting_spawn = Vector2(-100, -100)
	for i in range(projectile_count):
		var proj = projectile_scene.instantiate()
		game_node.add_child.call_deferred(proj)
		proj.global_position = starting_spawn 
		ready_projectiles.append(proj)	
		projectiles.append(proj)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(projectiles.size()):
		var proj = projectiles[i]
		if proj == null || !proj.fired:
			continue
		proj.position += proj.direction*proj.speed * delta
		if collision_check(proj):
			kill_projectile(proj)
		if proj.position.x > 2000 || proj.position.x < -300 || proj.position.y > 2000 || proj.position.y < -300:
			kill_projectile(proj)