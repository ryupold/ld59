extends Tower

@export var gravity: float = 1500

func towerEffect(): return Effect.GRAVITY

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var offset := packet.global_position.direction_to(global_position)
		packet.apply_force(offset.normalized() * gravity)
	return
