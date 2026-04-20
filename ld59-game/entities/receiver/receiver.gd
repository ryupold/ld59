extends Node2D
class_name Receiver

@export var patienceDecreaseFactor : float = 1
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
		if value < 25:
			patienceProgressBar.tint_progress = Color.RED
		elif value < 50:
			patienceProgressBar.tint_progress = Color.ORANGE
		elif value < 75:
			patienceProgressBar.tint_progress = Color.YELLOW
		else:
			patienceProgressBar.tint_progress = Color.GREEN

func _ready():
	prepareForNextWave(1)
	GameState.onNextWave.connect(prepareForNextWave)
	GameState.onGameTick.connect(onGameTick)
	
	GameState.onPacketLost.connect(func(): startOrEndCall())
	GameState.onPacketReceived.connect(func(payload): startOrEndCall())
	
func prepareForNextWave(wave: int):
	patience = 100
	updateRequiredSignal()
	currentState = State.CallIncoming
	patienceDecreaseFactor = wave

func onGameTick():
	updateRequiredSignal()
	updatePatience()
	updateAnimation()

func updateAnimation():
	if currentState == State.CallIncoming:
		$AnimatedSprite2D.animation = "incoming"
	elif GameState.isConnectionGood:
		$AnimatedSprite2D.animation = "good"
	else:
		$AnimatedSprite2D.animation = "bad"

func updatePatience():
	if currentState == State.CallIncoming: return
	
	if not GameState.isConnectionGood:
		patience -= patienceDecreaseFactor
	if patience <= 0:
		print("AAAARRGGHHH!!!")

func updateRequiredSignal():
	$RequiredSignalLabel.text = "required signal\n" + ("%.2f" % GameState.minSignal)
	
func startOrEndCall():
	if GameState.packetsToSend > 0:
		currentState = State.InCall
	else:
		currentState = State.CallIncoming
