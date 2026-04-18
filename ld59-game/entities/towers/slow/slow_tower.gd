extends Tower

@export var slowDownFactor: float = 0.5
@export var minParticleSpeed: float = 100

func _physics_process(delta: float) -> void:
	for packet in packetsColliding:
		if packet.linear_velocity.length() < minParticleSpeed:
			continue
			
		var velocity := packet.linear_velocity - (packet.linear_velocity * slowDownFactor * delta)
		if velocity.length() < minParticleSpeed:
			velocity = velocity.normalized() * minParticleSpeed
		packet.set_axis_velocity(velocity)
