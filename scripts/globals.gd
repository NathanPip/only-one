extends Node

signal reset_game

enum GameStateEnum {GAMEOVER, MENU, PAUSE, PLAYING}

@export var starting_game_state: GameStateEnum = GameStateEnum.PLAYING
var game_state: GameStateEnum = GameStateEnum.PLAYING:
	set(val):
		game_state = val
		set_node_states()
	get:
		return game_state

@export var starting_health: int = 3
var health: int = 3:
	set(val):
		health = val
		if val <= 0:
			game_state = GameStateEnum.GAMEOVER
	get:
		return health
var game_speed: float = 1
var score: float = 0
var game_node: Game
var game_over_node: Control
var menu_node: Control

func set_node_states():
	game_node.set_process(game_state == GameStateEnum.PLAYING)
	game_node.set_physics_process(game_state == GameStateEnum.PLAYING)
	for child in game_node.get_children():
		child.set_process(game_state == GameStateEnum.PLAYING)
		child.set_physics_process(game_state == GameStateEnum.PLAYING)
	game_over_node.set_process_input(game_state == GameStateEnum.GAMEOVER)
	game_over_node.visible = game_state == GameStateEnum.GAMEOVER

func restart():
	game_state = GameStateEnum.PLAYING
	health = starting_health
	game_speed = 1
	score = 0
	pass

func _ready() -> void:
	game_node = get_tree().get_root().get_node("Node2D").get_node("Game")
	game_over_node = get_tree().get_root().get_node("Node2D").get_node("GameOver")
	set_node_states()
	health = starting_health
	game_state = starting_game_state
	reset_game.connect(restart)
	pass
