extends CanvasLayer

@export var button: Button
@export var buttonSelector: Button
@export var buttonChooser: Button
@export var levelSelector: LevelSelectorCanvasItem
@export var towerChooser: TowerChooserCanvasItem

func _ready() -> void:
	button.pressed.connect(GameState.restartLevel)
	buttonSelector.pressed.connect(levelSelector.toggleSelector)
	buttonChooser.pressed.connect(towerChooser.toggleRandom)
