extends VBoxContainer

@export var levelCanvasItem: PackedScene = preload("res://hud/level_selector/level_canvas_item.tscn")
@export var buttonParent: Control

func _ready() -> void:
	for child in buttonParent.get_children():
		child.queue_free()

	for ressource: LevelResource in GameState.levels:
		var canvasItem: LevelCanvasItem = levelCanvasItem.instantiate()
		canvasItem.resource = ressource
		buttonParent.add_child(canvasItem)
