extends Tower

@export var gravity: float = 15

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var offset := packet.global_position.direction_to(global_position)
		packet.apply_impulse(offset.normalized() * gravity)
	return
