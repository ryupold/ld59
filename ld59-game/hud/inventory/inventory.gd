extends HFlowContainer

@export var towerCanvasItem: PackedScene = preload("res://hud/inventory/tower_canvas_item/tower_canvas_item.tscn")


func _ready() -> void:
	for child in get_children():
		child.queue_free()

	for tower: TowerResource in GameState.inventory:
		spawnTowerCanvasItem(tower)

	GameState.onInventoryChanged.connect(updateInventoryDisplay)

func updateInventoryDisplay() -> void:
	var proccesedTowers: Array[TowersResource] = []
	for node: Node in get_children():
		if node is TowerCanvasItem:
			var tower := node as TowerCanvasItem
			var amount = GameState.inventory[tower.towerResource]
			tower.maxAmount = amount
			proccesedTowers.append(tower.towerResource)

	for tower in GameState.inventory:
		if proccesedTowers.has(tower): continue
		spawnTowerCanvasItem(tower)


func spawnTowerCanvasItem(tower: TowerResource):
	var amount = GameState.inventory[tower]
	var canvasItem: TowerCanvasItem = towerCanvasItem.instantiate()
	canvasItem.towerResource = tower
	canvasItem.maxAmount = amount
	add_child(canvasItem)
