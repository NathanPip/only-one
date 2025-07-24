class_name Projectile
extends Sprite2D

@export var speed = 200
@export var size: float = 16
var direction: Vector2 = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale *= size/16
	pass # Replace with function body.
