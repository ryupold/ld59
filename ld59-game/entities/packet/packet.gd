extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5
@export var degradation: int
@export var growthModifier := 2.3
@export var minSpeed: float = 100
@export var maxSpeed: float = 5000
@export var payload: int = 1
var originalScales: Array[Vector2] = []

func _ready() -> void:
	for c in get_children()	:
		if c is Node2D:
			originalScales.append(c.scale)
			
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
	for i in get_child_count():
		var child := get_child(i)
		if child is Node2D:
			var newScale := originalScales[i] * (1 + (payload-1) * growthModifier)
			child.scale = newScale

func increaseTtl(by: int) -> void:
	ttl += by
	
func setVelocity(v: Vector2):
	if v.length_squared() < minSpeed * minSpeed:
		v = v.normalized() * minSpeed
	elif v.length_squared() > maxSpeed * maxSpeed:
		v = v.normalized() * maxSpeed
	set_axis_velocity(v)
