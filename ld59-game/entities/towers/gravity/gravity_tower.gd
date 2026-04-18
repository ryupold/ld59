extends Tower

func _process(delta: float) -> void:
	for packet in packetsColliding:
		var offset := packet.global_position.direction_to(global_position)
		packet.apply_impulse(offset.normalized() * 10)
	return
