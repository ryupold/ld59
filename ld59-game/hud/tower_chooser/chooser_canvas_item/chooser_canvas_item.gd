class_name ChooserCanvasItem extends Button

@export var resource: TowerResource
@export var nameLabel: Label
@export var texture: TextureRect
@export var descriptionLabel: Label
var hideParent: Callable

func _ready() -> void:
	texture.texture = resource.previewImage
	pressed.connect(handleSelect)
	nameLabel.text = resource.title
	descriptionLabel.text = resource.description

func handleSelect():
	var value = GameState.inventory.get_or_add(resource, 0)
	GameState.setInventory(resource, value + 1)
	hideParent.call()
	pass
