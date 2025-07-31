@tool
class_name Spawner
extends Node2D

signal ready_to_fire(spawner: Spawner)

var shoot_direction: Vector2 = Vector2(1, 0)
var draw_dir: Vector2 = Vector2.ZERO
var spawner_group: SpawnerGroup
var wait_time: = 0:
	set(val):
		wait_time = val
		if val <= 0:
			ready_to_fire.emit(self)
	get:
		return wait_time

var current_rotation: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner_group = get_parent()
	draw_dir = shoot_direction*30
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wait_time > 0:
		wait_time -= delta
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	draw_line(Vector2.ZERO, draw_dir, Color.RED)
	draw_circle(Vector2.ZERO, 10.0, Color.GREEN, false)