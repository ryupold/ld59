class_name TowerChooserCanvasItem extends VBoxContainer

@export var chooserCanvasItem: PackedScene = preload("res://hud/tower_chooser/chooser_canvas_item/chooser_canvas_item.tscn")
@export var buttonParent: Control

func _ready() -> void:
	GameState.onLevelUp.connect(showSelector)

func showSelector(towers: Array[TowerResource]) -> void:
	for child in buttonParent.get_children():
		child.queue_free()
	for resource in towers:
		var canvasItem: ChooserCanvasItem = chooserCanvasItem.instantiate()
		canvasItem.resource = resource
		canvasItem.hideParent = hide
		buttonParent.add_child(canvasItem)
	show()
	get_tree().paused= true
