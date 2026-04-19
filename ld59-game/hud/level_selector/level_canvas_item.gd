class_name LevelCanvasItem extends MarginContainer

@export var resource: LevelResource
@export var disabled:bool:
	get:
		return button.disabled
	set(value):
		button.disabled = value
@export var button: Button

func _ready() -> void:
	button.text = resource.Title
	button.pressed.connect(loadLevel)

func loadLevel():
	GameState.loadLevel(resource)
	pass
