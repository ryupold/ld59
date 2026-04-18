extends Control

func _ready():
	GameState.onPacketLost.connect(updateHUD)
	GameState.onPacketReceived.connect(func(payload): updateHUD())

func updateHUD():
	$PacketsLostLabel.text = str(GameState._packetsLost) + " packets lost"
	$PayloadReceivedLabel.text = str(GameState._payloadReceived) + " payload received"
	$PayloadPerSecondLabel.text = ("%.2f" % GameState._payloadPerSecond) + " payload/s"
