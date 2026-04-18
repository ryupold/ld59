extends Tower

func _process(delta: float) -> void:
	for packet in packetsColliding:
		var offset := global_position.direction_to(packet.global_position)
		packet.apply_impulse(offset * 10)
	return
