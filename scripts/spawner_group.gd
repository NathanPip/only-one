class_name SpawnerGroup
extends Node2D

var spawners: Array[Spawner] = []
var removables: Array[int] = []
var game_node: Game

func prepare_projectile(proj: Projectile, speed_range: Vector2):
	var rand = randi_range(0, spawners.size()-1)
	var spawner = spawners[rand]
	proj.speed = randf_range(speed_range.x, speed_range.y)
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
			spawners.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
