extends Sprite2D

@export var border: ExBorder
@export var speed: float = 100
var attack_point: Vector2 = Vector2(0,0)
var attacking: bool = false
var traveling: bool = true 

func pick_point():
	var side = randi_range(0,3)
	var pos = border.global_position
	if side == 0:
		attack_point = Vector2(pos.x, pos.y + randf_range(0, border.size.y))
	elif side == 1:
		attack_point = Vector2(pos.x + border.size.x, pos.y + randf_range(0, border.size.y))
	elif side == 2:
		attack_point = Vector2(pos.x + randf_range(0, border.size.x), pos.y)
	else:
		attack_point = Vector2(pos.x + randf_range(0, border.size.x), pos.y + border.size.y)

func travel(delta: float):
	self.position = self.position.move_toward(attack_point, delta*speed)
	if self.position.distance_to(attack_point) <= 2:
		pick_point()

func _ready() -> void:
	if border == null:
		print("no ex border assigned")
		get_tree().quit()
	
	pick_point()
	pass

func _process(delta: float) -> void:
	if traveling:
		travel(delta)
	pass
