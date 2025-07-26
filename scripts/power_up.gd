class_name PowerUp
extends Node

enum power_up_type {INVULNERABLE}

@export var type: power_up_type = power_up_type.INVULNERABLE
@export var duration: float = 1

func _activate(player: Player):
    pass

func _deactivate(player: Player):
    pass