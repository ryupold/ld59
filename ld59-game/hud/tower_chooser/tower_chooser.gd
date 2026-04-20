class_name TowerChooserCanvasItem extends VBoxContainer

@export var chooserCanvasItem: PackedScene = preload("res://hud/tower_chooser/chooser_canvas_item/chooser_canvas_item.tscn")
@export var buttonParent: Control

func _ready() -> void:
	updateTowers()

func toggleRandom() -> void:
	updateTowers()
	if visible:
		hide()
	else:
		show()

func updateTowers() -> void:
	for child in buttonParent.get_children():
		child.queue_free()
	for resource in GameState.allTowers.towers:
		var canvasItem: ChooserCanvasItem = chooserCanvasItem.instantiate()
		canvasItem.resource = resource
		buttonParent.add_child(canvasItem)
