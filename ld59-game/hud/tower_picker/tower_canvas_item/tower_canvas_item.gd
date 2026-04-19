class_name TowerCanvasItem extends PanelContainer

@export var towerResource: TowerResource
@export var button: Button

func _ready() -> void:
	button.icon = towerResource.previewImage
	button.pressed.connect(spawnTower)
	GameState.onDragEvent.connect(func(n, state: bool): button.disabled = state)

func spawnTower():
	var newTower: Tower = towerResource.scene.instantiate()
	newTower.pickup()
	get_tree().get_current_scene().get_node("%Towers").add_child(newTower)
	pass
