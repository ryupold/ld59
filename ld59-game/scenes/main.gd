extends Node2D

@export var start:Button
@export var levels:Button
@export var levelSelector: PackedScene = preload("res://hud/level_selector/level_selector.tscn")

func _ready() -> void:
	start.pressed.connect(func(): GameState.loadLevel(GameState.levels[0]))
	levels.pressed.connect(showLevelSelector)

func showLevelSelector():
	var selector = levelSelector.instantiate() as LevelSelectorCanvasItem
	selector.show()
	$CanvasLayer.add_child(selector)
