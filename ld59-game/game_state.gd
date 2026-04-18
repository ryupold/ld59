extends Node

var _packetsLost: int

signal onPacketLost()

func _ready():
	onPacketLost.connect(increasePacketLossCounter)
	
func increasePacketLossCounter():
	_packetsLost += 1
