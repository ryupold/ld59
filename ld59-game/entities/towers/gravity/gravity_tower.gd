extends Tower

@export var gravity: float = 500000

const EPSILON: float = 0.01

func towerEffect() -> Tower.Effect: return Effect.GRAVITY

func doEffect(delta: float) -> void:
	for packet in packetsColliding:
		var offset := global_position - packet.global_position
		
		var distance := maxf(offset.length(), EPSILON)
		var strength := gravity * (1.0 / distance)
		packet.apply_force(offset.normalized() * strength)
		
		# old formula
		#packet.apply_force(offset.normalized() * gravity)
