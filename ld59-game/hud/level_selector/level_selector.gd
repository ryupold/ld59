class_name LevelSelectorCanvasItem extends VBoxContainer

@export var levelCanvasItem: PackedScene = preload("res://hud/level_selector/level_canvas_item.tscn")
@export var buttonParent: Control
@export var close: Button

func _ready() -> void:
	get_tree().paused = true
	close.pressed.connect(onClose)
	updateLevelSelect()

func toggleSelector() -> void:
	updateLevelSelect()
	if visible:
		hide()
	else:
		show()

func onClose():
	get_tree().paused = true
	queue_free()

func updateLevelSelect() -> void:
	for child in buttonParent.get_children():
		child.queue_free()
	for i in GameState.levels.size():
		var ressource: LevelResource = GameState.levels[i]
		var prev: LevelResource = GameState.levels[i-1]
		var canvasItem: LevelCanvasItem = levelCanvasItem.instantiate()
		canvasItem.resource = ressource
		canvasItem.disabled = false if i-1 == -1 else !prev.completed
		buttonParent.add_child(canvasItem)
