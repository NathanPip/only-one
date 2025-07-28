class_name Ex
extends Node2D

@export var border: ExBorder
@export var speed: float = 100
var attack_point: Vector2 = Vector2(0,0)
var attacking: bool = false
var traveling: bool = true 

func pick_point() -> Vector2:
	var side = randi_range(0,3)
	var pos = border.global_position
	if side == 0:
		return Vector2(pos.x, pos.y + randf_range(0, border.size.y))
	elif side == 1:
		return Vector2(pos.x + border.size.x, pos.y + randf_range(0, border.size.y))
	elif side == 2:
		return Vector2(pos.x + randf_range(0, border.size.x), pos.y)
	else:
		return Vector2(pos.x + randf_range(0, border.size.x), pos.y + border.size.y)

func wait_for_attack():
	pass

func choose_attach():
	pass

func travel(delta: float):
	self.position = self.position.move_toward(attack_point, delta*speed)
	if self.position.distance_to(attack_point) <= 1:
		self.position = attack_point
		attack_point = pick_point()

func reset():
	self.position = pick_point()
	pass

func _ready() -> void:
	if border == null:
		print("no ex border assigned")
		get_tree().quit()
	
	attack_point = pick_point()
	Globals.reset_game.connect(reset)
	pass

func _process(delta: float) -> void:
	if traveling:
		travel(delta)
	pass
