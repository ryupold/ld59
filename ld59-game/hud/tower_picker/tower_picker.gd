extends HFlowContainer

@export var towerCanvasItem: PackedScene = preload("res://hud/tower_picker/tower_canvas_item/tower_canvas_item.tscn")
@export var towers: Array[TowerResource]


func _ready() -> void:
	for child in get_children():
		child.queue_free()

	for tower in towers:
		var canvasItem: TowerCanvasItem = towerCanvasItem.instantiate()
		canvasItem.tower = tower
		add_child(canvasItem)
