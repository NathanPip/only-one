extends RichTextLabel

func change_text(amt: int):
	self.text = str(amt)

func _ready() -> void:
	Globals.count_up.connect(change_text)