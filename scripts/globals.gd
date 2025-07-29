extends Node

signal reset_game
signal health_changed(amt: int)
signal damage_taken
signal count_up(amt: int)
signal change_powerup(tex: Texture2D)
signal change_gamestate(state: GameStateEnum)
signal damage_anim_playing(amt: float)


enum power_up_type {INVULNERABLE}
enum projectile_type {BASIC_PROJECTILE, EX_PROJECTILE, INVULNERABLE_PROJECTILE, HEART_UP_PROJECTILE}
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
	damage_anim_time = starting_damage_anim_time
	if health <= 0:
		game_state = GameStateEnum.GAMEOVER

var game_speed: float = 1
var score: float = 0
var starting_damage_anim_time: float = 1
var damage_anim_time: float = 0
var next_second: int
var game_node: Game
var game_over_node: Control
var menu_node: Control
var background: Sprite2D
var main_chord: MusicStream
var piano_loop: MusicStream
var heart_beat: MusicStream
var fast_synth: MusicStream
var gated: MusicStream
var music_streams: Array[MusicStream]

func update_music(streams: Array[MusicStream]):
	for s in streams:
		if score < s.score_start || s.always_playing:
			continue
		s.volume_db = s.starting_db + min(sqrt((score-s.score_start)/(s.score_limit-s.score_start)), 1) * (s.max_db-s.starting_db)


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

func play_damage_anim():
	var anim_amt = sin(damage_anim_time*PI)
	print(anim_amt)
	background.material.set_shader_parameter("damage_amt", anim_amt)
	damage_anim_playing.emit(anim_amt)
	pass

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
	if damage_anim_time >= 0:
		play_damage_anim()
		damage_anim_time -= delta
	update_music(music_streams)
	score += delta
	if score >= next_second:
		next_second += 1
		count_up.emit(int(score))


func _ready() -> void:
	next_second = score + 1
	var main_node = get_tree().get_root().get_node("Node2D")
	game_node = main_node.get_node("Game")
	game_over_node = main_node.get_node("GameOver")
	background = game_node.get_node("Background")
	menu_node = main_node.get_node("MainMenu")
	main_chord = main_node.get_node("Main_Chord")
	fast_synth = main_node.get_node("Fast_Synth")
	piano_loop = main_node.get_node("Piano_Loop")
	heart_beat = main_node.get_node("Heart_Beat")
	gated = main_node.get_node("Gated")
	music_streams = [main_chord, fast_synth, piano_loop, heart_beat, gated]
	game_node.on_ready.connect(set_node_states)
	game_over_node.on_ready.connect(set_node_states)
	menu_node.on_ready.connect(set_node_states)
	health = starting_health
	game_state = starting_game_state
	reset_game.connect(restart)
	pass
