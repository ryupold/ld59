extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5
@export var payload: int = 1
@export var degradation: int
@export var growthModifier := 0.3
var originalSpriteScale: float
var originalColliderScale: float

func _ready() -> void:
	body_entered.connect(onCollision)
	originalSpriteScale = $Sprite.scale.x
	originalColliderScale = $CollisionShape2D.scale.x

func onCollision(body: Node2D) -> void:
	if body is Receiver:
		GameState.onPacketLost.emit(payload)
		queue_free()
	else: # its a wall (probably)
		ttl -= 1
		if ttl == 0:
			GameState.onPacketLost.emit()
			queue_free()

func increasePayload() -> void:
	payload += 1
	var newSpriteScale := originalSpriteScale * (1 + (payload-1) * growthModifier)
	$Sprite.scale = Vector2(newSpriteScale, newSpriteScale)
	#($CollisionShape2D.shape as CircleShape2D).radius = originalColliderRadius * (1 + (payload-1) * growthModifier)
	var newColliderScale = originalColliderScale * (1 + (payload-1) * growthModifier)
	$CollisionShape2D.scale = Vector2(newColliderScale, newColliderScale)

func increaseTtl() -> void:
	ttl += 1
