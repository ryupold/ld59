extends Tower

@export var speedUpFactor: float = 0.5

func towerEffect(): return Effect.SPEED

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var velocity := packet.linear_velocity + (packet.linear_velocity * speedUpFactor * delta)
		packet.setVelocity(velocity)
