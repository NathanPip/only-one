@tool
class_name Spawner
extends Node2D

var shoot_direction: Vector2 = Vector2(1, 0)
var draw_dir: Vector2 = Vector2.ZERO
var spawner_group: SpawnerGroup

var current_rotation: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner_group = get_parent()
	draw_dir = shoot_direction*30
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2.ZERO, draw_dir, Color.RED)
	draw_circle(Vector2.ZERO, 10.0, Color.GREEN, false)