extends Node2D

func _ready() -> void:
	GameState.onNextWave.connect(cleanPackets)

func cleanPackets(nr :int):
	var children := get_children()
	for node in children:
		if node is Packet:
			node.loose()
		else: node.queue_free()
