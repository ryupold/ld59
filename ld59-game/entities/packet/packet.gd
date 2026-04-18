extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5;
@export var payload: int = 1;
@export var degradation: int;

func _ready() -> void:
	body_entered.connect(onCollision)

func onCollision(body: Node2D) -> void:
	ttl -= 1
	if ttl <= 0:
		GameState.onPacketLost.emit()
		queue_free()

func increasePayload() -> void:
	payload += 1
	var newScale := (Vector2.ONE * payload)
	for child in get_children():
		if child is Node2D:
			child.scale = newScale
