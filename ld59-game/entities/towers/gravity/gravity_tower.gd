extends Tower

@export var gravity: float = 9.81

func _physics_process(delta: float) -> void:
	for packet in packetsColliding:
		var offset := packet.global_position.direction_to(global_position)
		packet.apply_impulse(offset.normalized() * gravity)
	return
