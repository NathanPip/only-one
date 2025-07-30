class_name Projectile
extends Node2D 

@export var speed: float = 200
@export var size: float = 16
@export var fired: bool = false
@export var type: Globals.projectile_type
@export var debug: bool = false 
var direction: Vector2 = Vector2(1, 0)

func set_border_material(mat: Material):
	get_node("Border").material = mat

func set_tex(tex: Texture2D):
	get_node("Sprite").texture = tex

func get_tex() -> Texture2D:
	return get_node("Sprite").texture

func set_border_tex(tex: Texture2D):
	get_node("Border").texture = tex

func _move(delta: float):
	self.position += self.direction*self.speed * delta
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if debug:
		queue_redraw()

func _draw() -> void:
	if debug:
		draw_rect(Rect2(-size/2/self.scale.x, -size/2/self.scale.y, size/self.scale.x, size/self.scale.y), Color.RED, false)