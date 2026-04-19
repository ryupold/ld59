extends Tower

@export var ttlIncrease: int = 5

func _ready() -> void:
	collisionArea.body_entered.connect(addCompute)

	collisionArea.scale = Vector2.ZERO
	var tween := create_tween().set_loops()
	tween.tween_property(collisionArea, "scale", Vector2.ONE, 1)
	tween.tween_interval(0.5)
	tween.tween_property(collisionArea, "scale", Vector2.ZERO, 0)
	tween.tween_interval(1)


func addCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packet.increaseTtl(ttlIncrease)
	return
