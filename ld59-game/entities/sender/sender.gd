extends Node2D

@export var packetScene: PackedScene = preload("res://entities/packet/packet.tscn")
@export var packetParent: Node2D
@export var spawnDistance: float
@export var spawnInterval: float = 1.0

func _ready():
	print(spawnInterval)
	$PacketCreationTimer.wait_time = spawnInterval
	$PacketCreationTimer.timeout.connect(createPacket)

func createPacket():
	var packet : Packet = packetScene.instantiate()
	packet.global_position = global_position
	packet.apply_impulse(Vector2.from_angle(randf_range(0, PI)) * 1000)
	packetParent.add_child(packet)
