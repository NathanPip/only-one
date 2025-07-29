class_name MusicStream
extends AudioStreamPlayer

@export var starting_db: float = 0
@export var score_start: float = 0
@export var score_limit: float = 10 
@export var max_db: float = -8
@export var always_playing: bool = true

func _ready() -> void:
	if always_playing:
		return
	volume_db = starting_db