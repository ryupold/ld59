extends Node2D

@export var packetScene: PackedScene = preload("res://entities/packet/packet.tscn")

func _on_packet_creation_timer_timeout():
	var packet := packetScene.instantiate()
	packet.position = position
	add_child(packet)
