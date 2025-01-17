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

var currentScoreTarget : int = 6:
	set(value):
		currentScoreTarget = value
		targetLabel.text = "Must Roll Over: " + str(currentScoreTarget)


var currentRollScore : int :
	
	set(value):
		
		currentRollScore = value
		await finished_round_end
		if(value >= currentScoreTarget):
			soundContainer.get_children()[1].play()
			totalScore += value
			
		else:
			soundContainer.get_children()[0].play()
			totalScore = 0
		cashOutButton.text = "Cash Out For: \n" +  str(totalScore / 5)
		if(currentRollScore < currentScoreTarget):
		
			currentRollLabel.label_settings.font_color = Color.BROWN
		
		else:
			
			currentRollLabel.label_settings.font_color = Color.WHITE

var scoreLabel : Label

var targetLabel : Label

var cashLabel : Label

var cashOutButton : Button

var soundContainer : Node3D

var callableArray := []

var callableArrayArgs := []

var diceContainer : Node3D

var currentRollLabel : Label

var isScoring : bool

signal finished_round_start

signal finished_round_end

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	
	if(Input.is_action_just_released("escape")):
		
		get_tree().quit()

func multiplyScore(amountToMult : int):
	
	return totalScore * amountToMult

func applyRoundEndScoreModifiers():
	
	var temp_score = 0
	
	for i in callableArray:
		
		temp_score += i.call()
		
	if(temp_score > 0):
			
		currentRollScore = temp_score
	
	if(callableArray.size() == 0):
		
		currentRollScore = preFinalScore
	
	callableArray = []
	listOfCurrentRollValues = []
	isScoring = false
	finished_round_end.emit()
	
func applyRoundStartScoreModifiers():
	
	var temp_score = 0
	
	for i in callableArray:
		
		temp_score += i.call()
		
	if(temp_score > 0):
			
		currentRollScore = temp_score
	
	if(callableArray.size() == 0):
		
		currentRollScore = preFinalScore
	
	callableArray = []
	listOfCurrentRollValues = []
	isScoring = false
	finished_round_start.emit()
