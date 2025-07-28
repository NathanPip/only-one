@tool
class_name ExBorder
extends Node2D

@export var size: Vector2 = Vector2(300, 200):
    set(val):
        queue_redraw()
        size = val
    get:
        return size
var curr_pos: Vector2

func _ready() -> void:
    curr_pos = self.position

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        if curr_pos != self.position:
            queue_redraw()
            curr_pos = self.position

func _draw() -> void:
    if Engine.is_editor_hint():
        draw_rect(Rect2(0, 0, size.x, size.y), Color.GREEN, false)
    pass