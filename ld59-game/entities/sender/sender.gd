extends Node2D

@export var packetScene: PackedScene = preload("res://entities/packet/packet.tscn")
@export var packetParent: Node2D
@export var spawnDistance: float

func _on_packet_creation_timer_timeout():
	var packet : Packet = packetScene.instantiate()
	packet.global_position = global_position + spawnDistance * Vector2.from_angle(randf() * 2 * PI)
	packet.apply_impulse((packet.global_position - global_position).normalized() * 1000)
	packetParent.add_child(packet)
