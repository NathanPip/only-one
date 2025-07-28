extends Projectile


func _on_impact(player: Player):
	Globals.health -= 1
	print(Globals.health)