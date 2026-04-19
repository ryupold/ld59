extends Tower

@export var ttlIncrease: int = 1

func towerEffect(): return Effect.TTL

func _ready() -> void:
	super._ready()

	effectArea.scale = Vector2.ZERO
	var tween := create_tween().set_loops()
	tween.tween_property(effectArea, "scale", Vector2.ONE, 1)
	tween.tween_interval(0.5)
	tween.tween_property(effectArea, "scale", Vector2.ZERO, 0)
	tween.tween_interval(1)


func enterCollision(body: Node2D) -> void:
	if disableEffect and body is not Packet:
		return
	var packet := body as Packet
	packet.increaseTtl(ttlIncrease)
	packet.setEffect(towerEffect(), true)
	return
