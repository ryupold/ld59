extends Tower

@export var collisionArea: Area2D;

var packetsColliding: Array[Packet];

func _ready() -> void:
	collisionArea.body_entered.connect(addCompute)
	collisionArea.body_exited.connect(removeCompute)

func _process(delta: float) -> void:
	for packet in packetsColliding:
		var offset := global_position - packet.global_position
		packet.apply_impulse(offset.normalized() *3)

	return

func addCompute(body: Node2D) -> void:
	print(body.name + " entered")

	if body is Packet:
		var packet := body as Packet
		packetsColliding.append(packet)

	return


func removeCompute(body: Node2D) -> void:
	print(body.name + " left")

	if body is Packet:
		var packet := body as Packet
		var pos := packetsColliding.find(packet)
		if pos == -1:
			return
		packetsColliding.remove_at(pos);
		print("removed: " + str(pos))
		print(packetsColliding.size())
	return
