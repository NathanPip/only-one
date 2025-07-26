class_name PowerUpProjectile
extends Projectile

@export var power_up: PowerUp

func _on_impact(player: Player):
    player.set_power_up(power_up)
    pass