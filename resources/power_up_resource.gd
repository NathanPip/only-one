class_name PowerUpRes
extends Resource

@export var projectile: PackedScene 
@export var powerup: PackedScene 
@export var type: Globals.power_up_type
@export var speed_range: Vector2 = Vector2(100, 200)
var ready_projectiles: Array[PowerUpProjectile] = []