extends CanvasLayer

@export var button: Button
@export var waveNumber: Label
@export var buttonSelector: Button
@export var buttonChooser: Button
@export var levelSelector: PackedScene = preload("res://hud/level_selector/level_selector.tscn")
@export var gameOver: PackedScene = preload("res://hud/game_over.tscn")

func _ready() -> void:
	button.pressed.connect(GameState.restartLevel)
	buttonSelector.pressed.connect(showLevelSelector)
	GameState.onGameOver.connect(showGameOver)
	GameState.onNextWave.connect(func(nr:int): waveNumber.text = str(nr))
	GameState.onGameFinished.connect(showGameFinished)

func showLevelSelector():
	var selector := levelSelector.instantiate() as LevelSelectorCanvasItem
	selector.show()
	add_child(selector)

func showGameOver():
	var selector := gameOver.instantiate()
	add_child(selector)

func showGameFinished():
	$GameFinished.visible = true
	get_tree().paused = true
