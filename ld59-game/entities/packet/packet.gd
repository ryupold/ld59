extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5
@export var payload: int = 1
@export var degradation: int
@export var growthModifier := 0.1

func _ready() -> void:
	body_entered.connect(onCollision)

func onCollision(body: Node2D) -> void:
	ttl -= 1
	if ttl <= 0:
		GameState.onPacketLost.emit()
		queue_free()

func increasePayload() -> void:
	payload += 1
	var newScale := Vector2.ONE * (1 + (payload-1) * growthModifier)
	for child in get_children():
		if child is Node2D:
			child.scale = newScale
