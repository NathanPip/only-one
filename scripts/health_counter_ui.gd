extends Control

var sprites: Array[TextureRect] = []

func change_hearts(health: int):
	for i in range(sprites.size()):
		var s = sprites[i]
		if i <= health-1:
			s.material.set_shader_parameter("dead_amt", 0)
		else:
			s.material.set_shader_parameter("dead_amt", 1)

func _ready() -> void:
	Globals.health_changed.connect(change_hearts)
	var heart = get_node("TextureRect")
	sprites.append(heart)
	for h in range(Globals.health-1):
		var nh = heart.duplicate()
		nh.material = heart.material.duplicate()
		add_child(nh)
		sprites.append(nh)
	pass
