extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5
@export var degradation: int
@export var growthModifier := 0.05
@export var minSpeed: float = 100
@export var maxSpeed: float = 5000
@export var maxTravelTime: float = 25000
@export var payload: int = 1
@export var sprites: Array[Texture2D] = []
var _originalScales: Array[Vector2] = []
var _travelTime: float

@onready var effectMap: Dictionary = {
	Tower.Effect.GRAVITY: $Effects/GravityEffect,
	Tower.Effect.ANTIGRAVITY: $Effects/AntigravityEffect,
	Tower.Effect.SPEED: $Effects/SpeedEffect,
	Tower.Effect.SLOW: $Effects/SlowEffect,
	Tower.Effect.TTL: $Effects/TTLEffect,
	Tower.Effect.PAYLOAD: $Effects/PayloadEffect,
}

var activeEffects: Dictionary = {
	Tower.Effect.GRAVITY: 0,
	Tower.Effect.ANTIGRAVITY: 0,
	Tower.Effect.SPEED: 0,
	Tower.Effect.SLOW: 0,
	Tower.Effect.TTL: 0,
	Tower.Effect.PAYLOAD: 0,
}

func _ready() -> void:
	for c in get_children():
		if c is CanvasItem:
			_originalScales.append(c.scale)
			
	body_entered.connect(onCollision)

func onCollision(body: Node2D) -> void:
	if body is Receiver:
		GameState.onPacketReceived.emit(payload)
		queue_free()
	else: # its a wall (probably)
		ttl -= 1
		if ttl == 0:
			GameState.onPacketLost.emit()
			queue_free()

func increasePayload(by: int) -> void:
	payload += by
	$TextureRect.texture = sprites[clamp(payload, 0, sprites.size() - 1)]
	for i in get_child_count():
		var child := get_child(i)
		if child is CanvasItem:
			var newScale := _originalScales[i] * (1 + (payload-1) * growthModifier)
			child.scale = newScale

func increaseTtl(by: int) -> void:
	ttl += by
	
func setVelocity(v: Vector2):
	if v.length_squared() < minSpeed * minSpeed:
		v = v.normalized() * minSpeed
	elif v.length_squared() > maxSpeed * maxSpeed:
		v = v.normalized() * maxSpeed
	set_axis_velocity(v)

func setEffect(effectType: Tower.Effect, enabled: bool):
	var effectAnimation : AnimatedSprite2D = effectMap[effectType]
	if effectAnimation:
		if enabled:
			activeEffects[effectType] += 1
		else:
			activeEffects[effectType] = max(activeEffects[effectType] - 1, 0)
		effectAnimation.visible = activeEffects[effectType] > 0;
	else:
		print("unknown effect: " + str(effectType))
