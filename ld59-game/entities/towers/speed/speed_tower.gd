extends Tower

func _physics_process(delta: float) -> void:
	for packet in packetsColliding:
		var velocity := packet.linear_velocity + (packet.linear_velocity * 2 * delta)
		packet.set_axis_velocity(velocity)
	return
