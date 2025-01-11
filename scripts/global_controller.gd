extends Node

var totalScore : int

var preFinalScore : int

var listOfCurrentRollValues := []

signal finished_round_end

var currentRollScore : int :
	
	set(value):
		
		currentRollScore = value
		await finished_round_end
		totalScore += value
		scoreLabel.text = str("Score: " + str(totalScore))
		print("Total amount scored this round " + str(value))

var scoreLabel : Label

var callableArray := []

var callableArrayArgs := []

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
	
	callableArray = []
	listOfCurrentRollValues = []
	finished_round_end.emit()
