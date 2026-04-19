class_name TowerCanvasItem extends PanelContainer

@export var towerResource: TowerResource
@export var button: Button

func _ready() -> void:
	button.icon = towerResource.previewImage
	button.pressed.connect(spawnTower)

func spawnTower():
	var newTower: Tower = towerResource.scene.instantiate()
	newTower.followsMouse = true
	newTower.disableEffect = true
	get_tree().get_current_scene().get_node("%Towers").add_child(newTower)
	pass
