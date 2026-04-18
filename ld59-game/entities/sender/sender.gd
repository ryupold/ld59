extends Node2D

func _on_packet_creation_timer_timeout():
	var packet := Packet.new()
	packet.position = Vector2(10, 10)
	add_child(packet)
