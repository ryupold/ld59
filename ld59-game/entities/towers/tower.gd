class_name Tower extends Node2D

@export var collisionArea: Area2D
var packetsColliding: Array[Packet]
var usePackageList: bool = true

signal onPacketEnter(packet: Packet)
signal onPacketExit(packet: Packet)

func _ready() -> void:
	collisionArea.body_entered.connect(addCompute)
	collisionArea.body_exited.connect(removeCompute)

func addCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		onPacketEnter.emit(packet)
		if usePackageList:
			packetsColliding.append(packet)
	return


func removeCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		var pos := packetsColliding.find(packet)
		if pos == -1:
			return
		onPacketExit.emit(packet)
		if usePackageList:
			packetsColliding.remove_at(pos);
	return
