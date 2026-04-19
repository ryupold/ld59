extends CanvasLayer

@export var button: Button
@export var buttonSelector: Button
@export var levelSelector: LevelSelectorCanvasItem

func _ready() -> void:
	button.pressed.connect(GameState.restartLevel)
	buttonSelector.pressed.connect(levelSelector.toggleSelector)
