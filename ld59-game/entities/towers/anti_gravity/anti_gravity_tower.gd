extends Tower

@export var antiGravity: float = 1500

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var offset := global_position.direction_to(packet.global_position)
		packet.apply_force(offset.normalized() * antiGravity)
