extends Node

var totalScore : int :
	set(value):
		totalScore = value
		scoreLabel.text = str("Score: " + str(totalScore))
		print("Total amount scored this round " + str(value))

var preFinalScore : int

var playerCash : int :
	set(value):
		playerCash = value
		cashLabel.text = "Cash: " + str(playerCash)

var listOfCurrentRollValues := []

var currentScoreTarget : int = 10:
	set(value):
		currentScoreTarget = value
		targetLabel.text = "Minimum Roll to Score: " + str(currentScoreTarget)

signal finished_round_end

var currentRollScore : int :
	
	set(value):
		
		currentRollScore = value
		await finished_round_end
		totalScore += value
		

var scoreLabel : Label

var targetLabel : Label

var cashLabel : Label

var cashOutButton : Button

var callableArray := []

var callableArrayArgs := []

var diceContainer : Node3D

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	
	if(Input.is_action_just_released("escape")):
		
		get_tree().quit()

func multiplyScore(amountToMult : int):
	
	return totalScore * amountToMult

func applyRoundEndScoreModifiers():
	
	for i in callableArray:
		
		currentRollScore = i.call()
	
	if(callableArray.size() == 0):
		
		currentRollScore = preFinalScore
	
	if(currentRollScore < currentScoreTarget):
		
		currentRollScore = -totalScore
		
	
	callableArray = []
	listOfCurrentRollValues = []
	finished_round_end.emit()
