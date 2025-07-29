extends Node

signal reset_game
signal health_changed(amt: int)
signal damage_taken
signal count_up(amt: int)
signal change_powerup(tex: Texture2D)
signal change_gamestate(state: GameStateEnum)


enum power_up_type {INVULNERABLE}
enum projectile_type {BASIC_PROJECTILE, EX_PROJECTILE, INVULNERABLE_PROJECTILE}
enum GameStateEnum {GAMEOVER, MENU, PAUSE, PLAYING}

@export var starting_game_state: GameStateEnum = GameStateEnum.MENU
var game_state: GameStateEnum = GameStateEnum.PAUSE:
	set(val):
		game_state = val
		change_gamestate.emit(val)
		set_node_states()
	get:
		return game_state

@export var starting_health: int = 3
var health: int = 3:
	set(val):
		health = val
		health_changed.emit(val)
	get:
		return health

func take_damage(amount: int):
	health -= amount 
	damage_taken.emit()
	if health <= 0:
		game_state = GameStateEnum.GAMEOVER

var game_speed: float = 1
var score: float = 0
var next_second: int
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
	menu_node.set_process_input(game_state == GameStateEnum.MENU)
	menu_node.visible = game_state == GameStateEnum.MENU

func restart():
	game_state = GameStateEnum.PLAYING
	health = starting_health
	game_speed = 1
	score = 0
	next_second = score + 1
	count_up.emit(0)
	pass

func _process(delta: float) -> void:
	game_speed += delta/100
	if game_state != GameStateEnum.PLAYING:
		return
	score += delta
	if score >= next_second:
		next_second += 1
		count_up.emit(int(score))


func _ready() -> void:
	next_second = score + 1
	game_node = get_tree().get_root().get_node("Node2D").get_node("Game")
	game_over_node = get_tree().get_root().get_node("Node2D").get_node("GameOver")
	menu_node = get_tree().get_root().get_node("Node2D").get_node("MainMenu")
	game_node.on_ready.connect(set_node_states)
	game_over_node.on_ready.connect(set_node_states)
	menu_node.on_ready.connect(set_node_states)
	health = starting_health
	game_state = starting_game_state
	reset_game.connect(restart)
	pass
