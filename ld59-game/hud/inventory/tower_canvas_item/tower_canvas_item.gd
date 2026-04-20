class_name TowerCanvasItem extends PanelContainer

@export var towerResource: TowerResource
@export var button: Button
@export var amountLabel: Label
var _amount: int = 0
var _maxAmount: int = 0
@export var amount: int :
	get:
		return _amount
	set(value):
		_amount = value
		determineDisabled()
		setAmountText()
@export var maxAmount: int :
	get:
		return _maxAmount
	set(value):
		amount += value - _maxAmount
		_maxAmount = value

var towerType: Object

func _ready() -> void:
	var tempTower: Tower = towerResource.scene.instantiate()
	towerType = tempTower.get_script()
	tempTower.queue_free()

	button.icon = towerResource.previewImage
	button.pressed.connect(spawnTower)
	button.tooltip_text = towerResource.title
	GameState.onDragEvent.connect(func(_n, _s): determineDisabled())
	GameState.onPlaceInventory.connect(onPlaceInInventory)

func spawnTower():
	var newTower: Tower = towerResource.scene.instantiate()
	newTower.pickup()
	newTower.global_position = get_global_mouse_position()
	get_tree().get_current_scene().get_node("%Towers").add_child(newTower)
	amount -= 1
	pass

func determineDisabled() -> void:
	if _amount <= 0 || GameState._isDragging:
		button.disabled = true
	elif !GameState._isDragging:
		button.disabled = false

func setAmountText():
	amountLabel.text = "" + str(_amount)

func onPlaceInInventory(tower: Tower):
	if tower.get_script() == towerType:
		amount += 1
