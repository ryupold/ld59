class_name Tower extends Node2D

@export var collisionArea: Area2D;
var packetsColliding: Array[Packet];

func _ready() -> void:
	collisionArea.body_entered.connect(addCompute)
	collisionArea.body_exited.connect(removeCompute)

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
