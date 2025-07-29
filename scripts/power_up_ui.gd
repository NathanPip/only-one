extends TextureRect

var power_up_tex: TextureRect

func set_powerup(tex: Texture2D):
	power_up_tex.texture = tex

func reset():
	power_up_tex.texture = null

func _ready() -> void:
	power_up_tex = get_node("PowerUp_Texture")
	Globals.change_powerup.connect(set_powerup)
	Globals.reset_game.connect(reset)