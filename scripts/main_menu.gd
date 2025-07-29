extends Control

signal on_ready

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Globals.game_state = Globals.GameStateEnum.PLAYING

func _ready() -> void:
	on_ready.emit()