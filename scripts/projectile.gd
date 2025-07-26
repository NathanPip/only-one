class_name Projectile
extends Sprite2D

@export var speed: float = 200
@export var size: float = 16
@export var fired: bool = false
var direction: Vector2 = Vector2(1, 0)

func _on_impact(player: Player):
	pass

func _move(delta: float):
	self.position += self.direction*self.speed * delta
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale *= size/16
	pass # Replace with function body.
