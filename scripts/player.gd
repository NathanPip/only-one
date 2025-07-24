class_name Player
extends CharacterBody2D

@export var speed = 300.0

func get_input():
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * speed 
	else:
		velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
