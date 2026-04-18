extends Node

var _packetsLost: int

var _payloadReceived: int
var _payloadPerSecond: float
var _currentPayloadBuffer: float
var _currentPayloadBufferTime: float

signal onPacketLost()
signal onPacketReceived()

func _ready():
	onPacketLost.connect(increasePacketLossCounter)
	onPacketReceived.connect(receivePacket)
	
func increasePacketLossCounter():
	_packetsLost += 1
	
func receivePacket(payload: int):
	_payloadReceived += payload
	_currentPayloadBuffer += payload

func _process(delta):
	_currentPayloadBufferTime += delta
	if _currentPayloadBufferTime >= 1:
		_currentPayloadBufferTime -= 1
		_payloadPerSecond = (_payloadPerSecond + _currentPayloadBuffer) / 2
		_currentPayloadBuffer = 0
