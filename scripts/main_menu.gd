extends Control

signal on_ready

@export var screens: Array[Control] = []
var current_screen = 0

func show_next():
	current_screen += 1
	if current_screen > 0:
		screens[current_screen-1].visible = false
	screens[current_screen].visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if current_screen < screens.size()-1:
			show_next()
		else:
			Globals.game_state = Globals.GameStateEnum.PLAYING
			current_screen = -1
			show_next()

func _ready() -> void:
	on_ready.emit()
