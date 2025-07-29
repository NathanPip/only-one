extends RichTextLabel

var is_gameover: bool = false

func change_text(amt: int):
	if is_gameover:
		self.text = str(amt) + " Seconds"
	else:
		self.text = str(amt)

func _ready() -> void:
	Globals.count_up.connect(change_text)