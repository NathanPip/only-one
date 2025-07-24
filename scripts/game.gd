extends Node2D

var spawner_groups: Array[SpawnerGroup] = []
var timer: Timer 
var wait_range: Vector2 = Vector2(.2, .8)

func _on_timeout():
	var rand_spawn = randi_range(0, 3)
	var spawner = spawner_groups[rand_spawn]
	spawner.fire_projectile()
	var rand = randf_range(wait_range.x, wait_range.y)
	timer.wait_time = rand
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("Timer")
	timer.timeout.connect(_on_timeout)
	for child in get_children():
		if child is SpawnerGroup:
			spawner_groups.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
