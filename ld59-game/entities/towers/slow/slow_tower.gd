extends Tower

@export var slowDownFactor: float = 0.5

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var velocity := packet.linear_velocity - (packet.linear_velocity * slowDownFactor * delta)
		packet.setVelocity(velocity)
