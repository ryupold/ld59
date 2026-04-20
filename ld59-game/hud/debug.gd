extends Control

func _process(delta):
	$PacketsLostLabel.text = str(GameState._packetsLost) + " packets lost"
	$PayloadReceivedLabel.text = str(GameState._payloadReceived) + " payload received"
	$PayloadPerSecondLabel.text = ("%.2f" % GameState._signal) + " signal"
