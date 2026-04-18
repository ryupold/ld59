extends Node2D

func _on_packet_creation_timer_timeout():
	var packet := Packet.new()
	packet.position = position
	add_child(packet)
