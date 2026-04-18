extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5;
@export var payload: int = 1;
@export var degradation: int;

func _ready():
	body_entered.connect(onCollision)

func onCollision(body: Node2D):
	ttl -= 1
	if ttl <= 0:
		GameState.onPacketLost.emit()
		queue_free()

func increasePayload():
	print("kfnsdfnsdfkjn")
	payload += 1
	set_scale(Vector2.ONE * payload )
