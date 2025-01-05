extends Node3D

@export var scoreLabel : Label

var diceArray := []

var canRoll = true

var hasRolledOnce = false

var currentRollScore := 0

func _ready():
	
	for i in get_children():
		
		diceArray.append(i)
	
	for i in diceArray:
		
		i.done_rolling.connect(checkForRolling)

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("roll_dice") && canRoll):
		print("Rolling dice")
		hasRolledOnce = true
		canRoll = false
		rollAllDice()

func checkForRolling():
	
	for i in diceArray:
		
		if !i.is_sleeping():
			
			return
	
	print("Can roll is true")
	
	canRoll = true
	
	if(hasRolledOnce):
		await get_tree().create_timer(.2).timeout
		checkForDuplicateNumbersThenScore()
		
func rollAllDice():
	
	for i in diceArray:
		
		i.rollDice()

func checkForDuplicateNumbersThenScore():
	
	var value_array = []
	
	var scored_dice_array = []
	
	var score := 0
	
	var previous_number = 0
	
	for i in diceArray:
	
		value_array.append(i.currentRollValue)
		print("Value after rolling " + str(i.currentRollValue))
		
	for i in diceArray:
		
		var current_num = i.currentRollValue
		
		var number_occurrence = value_array.count(current_num)
		
		if(number_occurrence > 1 && previous_number != current_num):
			scored_dice_array.append(i)
			previous_number = current_num
			print("Adding " + str(number_occurrence * current_num) + " to score")
			score += number_occurrence * current_num
		elif(previous_number == current_num):
			scored_dice_array.append(i)
	
	if(previous_number == 0 && score == 0):
		
		scored_dice_array.append(diceArray[value_array.find(value_array.max())])
		
		score += value_array.max()
	
	for i in scored_dice_array:
		print("Scored: " + str(i.currentRollValue))
	
	currentRollScore = score
	var tween = get_tree().create_tween()
	tween.tween_property(scoreLabel,"text", "Winnings: " + str(int(scoreLabel.text) + score), .7)
	
	
	print("Round Score is " + str(score))
