extends Node2D
class_name Receiver

@onready var patienceProgressBar := $TextureProgressBar
var currentState: State = State.CallIncoming

enum State {
	CallIncoming,
	InCall,
}

var patience : float:
	get:
		return patienceProgressBar.value
	set(value):
		patienceProgressBar.value = value
		updateAnimation()

func _ready():
	prepareForNextWave(1)
	GameState.onNextWave.connect(prepareForNextWave)
	GameState.onGameTick.connect(onGameTick)

	GameState.onPacketLost.connect(func(): startOrEndCall())
	GameState.onPacketReceived.connect(func(payload): startOrEndCall())

func prepareForNextWave(wave: int):
	currentState = State.CallIncoming
	patience = 100
	updateLabels()
	updateAnimation()

func onGameTick():
	updateLabels()
	updatePatience()
	updateAnimation()

func updateAnimation():
	if currentState == State.CallIncoming:
		$AnimatedSprite2D.animation = "incoming"
		patienceProgressBar.visible = false
		#$RequiredLabel.visible = false
		$SignalLabel.visible = false
		$SignalProgressBar.visible = false
	elif GameState.isConnectionGood:
		$AnimatedSprite2D.animation = "good"
		patienceProgressBar.visible = true
		#$RequiredLabel.visible = true
		$SignalLabel.visible = true
		$SignalProgressBar.visible = true
	else:
		$AnimatedSprite2D.animation = "bad"
		patienceProgressBar.visible = true
		#$RequiredLabel.visible = true
		$SignalLabel.visible = true
		$SignalProgressBar.visible = true
	
	if GameState.isConnectionGood:
		patienceProgressBar.tint_progress = Color.DIM_GRAY
	elif patience < 25:
		patienceProgressBar.tint_progress = Color.RED
	elif patience < 50:
		patienceProgressBar.tint_progress = Color.ORANGE
	elif patience < 75:
		patienceProgressBar.tint_progress = Color.YELLOW
	else:
		patienceProgressBar.tint_progress = Color.GREEN

func updatePatience():
	if currentState == State.CallIncoming: return

	if not GameState.isConnectionGood:
		patience -= GameState.minSignal - GameState._signal
	if patience <= 0:
		print("AAAARRGGHHH!!!")
		GameState.onGameOver.emit()

func updateLabels():
	$RequiredLabel.text = ("%.2f" % GameState.minSignal)
	$SignalLabel.text = ("%.2f" % GameState._signal)
	$SignalProgressBar.max_value = GameState.minSignal
	$SignalProgressBar.value = GameState._signal
	
func startOrEndCall():
	if GameState.packetsToSend > 0:
		currentState = State.InCall
	else:
		currentState = State.CallIncoming
