extends HFlowContainer

@export var towerCanvasItem: PackedScene = preload("res://hud/tower_picker/tower_canvas_item/tower_canvas_item.tscn")


func _ready() -> void:
	for child in get_children():
		child.queue_free()

	for tower: TowerResource in GameState.unlockedTowers.towers:
		var canvasItem: TowerCanvasItem = towerCanvasItem.instantiate()
		canvasItem.towerResource = tower
		add_child(canvasItem)
