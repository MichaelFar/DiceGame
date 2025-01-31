extends Node

var bbcodePrefix = "[woo][heart]"

var tempScore = 0

var totalScore : int :
	set(value):
		totalScore = value
		scoreLabel.bbcode = str(bbcodePrefix + "Score: " + str(totalScore))
		print("Total amount scored this round " + str(value))

var preFinalScore : int = 0

var playerCash : int :
	set(value):
		playerCash = value
		cashLabel.bbcode = bbcodePrefix + "Cash: " + str(playerCash)

var listOfCurrentRollValues := []

var currentScoreTarget : int = 6:
	set(value):
		currentScoreTarget = value
		targetLabel.bbcode = bbcodePrefix + "Target: " + str(currentScoreTarget)

var cashoutButtonRTL : RicherTextLabel

var currentRollScore : int :
	
	set(value):
		
		currentRollScore = value
		
		
		await finished_round_end
		
		if(currentRollScore >= currentScoreTarget):
			soundContainer.get_children()[1].play()
			totalScore += value
			
		else:
			soundContainer.get_children()[0].play()
			totalScore = 0
			
		cashoutButtonRTL.bbcode = bbcodePrefix + "Cash Out For: " +  str(totalScore / 5)
		
		if(currentRollScore < currentScoreTarget):
		
			pass
			#currentRollLabel.self_modulate = Color.BROWN
		
		else:
			pass
			#currentRollLabel.self_modulate = Color.WHITE

var scoreLabel : RicherTextLabel

var targetLabel : RicherTextLabel

var cashLabel : RicherTextLabel

var cashOutButton : Button

var soundContainer : Node3D

var roundStartCallableArray := []

var roundEndCallableArray := []

var callableArrayArgs := []

var diceContainer : Node3D

var currentRollLabel : RicherTextLabel

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
	
	
	for i in roundEndCallableArray:
		
		tempScore += i.call()
		
	if(tempScore > 0):
			
		currentRollScore = tempScore
	
	if(roundEndCallableArray.size() == 0):
		
		currentRollScore = preFinalScore
	
	roundEndCallableArray = []
	listOfCurrentRollValues = []
	isScoring = false
	finished_round_end.emit()
	
func applyRoundStartScoreModifiers():
	
	var tempScore = 0
	
	for i in roundStartCallableArray:
		
		tempScore += i.call()
		
	
	#if(roundStartCallableArray.size() == 0):
		#
		#currentRollScore = preFinalScore
	
	roundStartCallableArray = []
	
	
	finished_round_start.emit()
