extends Tower

func _process(delta: float) -> void:
	for packet in packetsColliding:
		var offset := packet.global_position.direction_to(global_position)
		packet.apply_impulse(offset.normalized() * 10)
	return

func addCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packetsColliding.append(packet)

	return


func removeCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		var pos := packetsColliding.find(packet)
		if pos == -1:
			return
		packetsColliding.remove_at(pos);
	return
