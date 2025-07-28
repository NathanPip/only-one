class_name PowerUp
extends Node

var type: Globals.power_up_type = Globals.power_up_type.INVULNERABLE
@export var duration: float = 1

func _activate(player: Player):
    pass

func _deactivate(player: Player):
    pass