class_name TowerCanvasItem extends PanelContainer

@export var tower: TowerResource
@export var button: Button

func _ready() -> void:
	button.icon = tower.previewImage
	button.pressed.connect(spawnTower)

func spawnTower():
	pass
