extends CanvasLayer

@export var button :Button

func _ready() -> void:
	button.pressed.connect(GameState.restartLevel)
