class_name ProjectileResource
extends Resource

@export var type: Globals.projectile_type
@export var damage_amt: int = 0
@export var speed_range: Vector2 = Vector2(100, 100)
@export var instantiation_count: int = 10
@export var projectile_scene: PackedScene
@export var additional_sprites: Array[Texture2D] = []
@export var border_mat: Material
var ready_projectiles: Array[Projectile] = []