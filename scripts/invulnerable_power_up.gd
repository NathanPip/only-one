extends PowerUp

func _activate(player: Player):
	player.invulnerable = true
	var color = player.modulate
	player.modulate = Color(color.a, color.g, color.b, .5)
	pass

func _deactivate(player: Player):
	player.invulnerable = false
	var color = player.modulate
	player.modulate = Color(color.a, color.g, color.b, 1)
	pass
