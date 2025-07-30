extends PowerUp

func _activate(player: Player):
	player.invulnerable = true
	pass

func _deactivate(player: Player):
	player.invulnerable = false
	pass
