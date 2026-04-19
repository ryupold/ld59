extends Tower

@export var payloadIncrease: int = 1

func _ready() -> void:
	super._ready()

	collisionArea.scale = Vector2.ZERO
	var tween := create_tween().set_loops()
	tween.tween_property(collisionArea, "scale", Vector2.ONE, 1)
	tween.tween_interval(0.5)
	tween.tween_property(collisionArea, "scale", Vector2.ZERO, 0)
	tween.tween_interval(1)


func addCompute(body: Node2D) -> void:
	if disableEffect and body is not Packet:
		return
	var packet := body as Packet
	packet.increasePayload(payloadIncrease)
	return
