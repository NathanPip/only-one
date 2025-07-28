extends Control

var container: HBoxContainer
var sprites: Array[Sprite2D]

func change_hearts(health: int):
	print(health)
	for i in range(sprites.size()):
		var s = sprites[i]
		print(i <= health-1)
		if i <= health-1:
			s.material.set_shader_parameter("dead_amt", 0)
		else:
			s.material.set_shader_parameter("dead_amt", 1)

func _ready() -> void:
	Globals.health_changed.connect(change_hearts)
	container = get_node("HBoxContainer")
	for c in container.get_children():
		sprites.append(c)
	pass
