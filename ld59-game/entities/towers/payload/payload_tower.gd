extends Tower

func _ready() -> void:
	super._ready()
	usePacketList = false
	onPacketEnter.connect(func(p:Packet): p.increasePayload())

	collisionArea.scale = Vector2.ZERO
	var tween := create_tween().set_loops()
	tween.tween_property(collisionArea, "scale", Vector2.ONE, 1)
	tween.tween_interval(0.5)
	tween.tween_property(collisionArea, "scale", Vector2.ZERO, 0)
	tween.tween_interval(1)
