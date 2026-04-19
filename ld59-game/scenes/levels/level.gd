class_name Level extends Node2D

@export var sender: Sender
@export var reciever: Receiver
@export var towers: Node2D
@export var packets: Node2D

func _ready() -> void:
	GameState.onLevelCreated.emit()
