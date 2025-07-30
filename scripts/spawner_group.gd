class_name SpawnerGroup
extends Node2D

var spawners: Array[Spawner] = []
var ready_spawners: Array[Spawner] = []
var removables: Array[int] = []
var game_node: Game

func ready_spawner(spawner: Spawner):
	ready_spawners.append(spawner)

func prepare_projectile(proj: Projectile, speed_range: Vector2):
	var rand = randi_range(0, ready_spawners.size()-1)
	var spawner = ready_spawners[rand]
	ready_spawners.remove_at(rand)
	proj.speed = randf_range(speed_range.x, speed_range.y)
	spawner.wait_time = proj.speed / 100
	if proj == null:
		print("no projectile")
		return
	var dir = spawner.shoot_direction.rotated(spawner.global_rotation)	
	proj.direction = dir
	proj.global_position = spawner.global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_node = get_tree().get_root().get_node("Node2D").get_node("Game")
	for child in get_children():
		if child is Spawner:
			child.ready_to_fire.connect(ready_spawner)
			spawners.append(child)
			ready_spawners.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
