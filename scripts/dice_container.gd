extends Node3D

@export var scoreLabel : Label

@export var diceResources : ResourcePreloader

@export var diceParent : Node3D

@export var spawnPoints : Node3D

var diceArray := []

var canRoll = true

var hasRolledOnce = false

var currentRollScore := 0

func _ready():
	
	GlobalController.scoreLabel = scoreLabel
	
	populateDice()

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("roll_dice") && canRoll):
		
		print("Rolling dice")
		
		hasRolledOnce = true
		
		canRoll = false
		
		rollAllDice()

func populateDice():
	
	var spawn_points_children = spawnPoints.get_children()
	
	for i in diceResources.get_resource_list():
		
		if(spawn_points_children.size() >= diceResources.get_resource_list().size()):
			
			var dice_instance = diceResources.get_resource(i)
			
			dice_instance = dice_instance.instantiate()
			
			diceParent.add_child(dice_instance)
			
			dice_instance.global_position = spawn_points_children[diceResources.get_resource_list().find(i)].global_position
	
	for i in diceParent.get_children():
		
		diceArray.append(i)
		
		i.done_rolling.connect(checkForRolling)
	
func checkForRolling():
	
	for i in diceArray:
		
		if !i.is_sleeping():
			
			return
	
	print("Can roll is true")
	
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
	
	var previous_number_array = []
	
	for i in diceArray:
	
		value_array.append(i.currentRollValue)
		print("Value after rolling " + str(i.currentRollValue))
		
	for i in diceArray:
		
		var current_num = i.currentRollValue
		
		var number_occurrence = value_array.count(current_num)
		
		if(number_occurrence > 1 && current_num not in previous_number_array && current_num > 0):
			
			scored_dice_array.append(i)
			previous_number_array.append(current_num)
			print("Adding " + str(number_occurrence * current_num) + " to score")
			score += number_occurrence * current_num
		
		elif(current_num in previous_number_array && current_num > 0):
			print("Scoring highest roll")
			scored_dice_array.append(i)
	
	if(score == 0):
		
		scored_dice_array.append(diceArray[value_array.find(value_array.max())])
		
		score += value_array.max()
	
	for i in scored_dice_array:
		
		i.scoreVisualEffect()
		
		scoreLabel.text = "Score: " + str(int(scoreLabel.text) + i.rolledSide.sideValue)
		
		await i.done_scoring
	
	canRoll = true
	
	currentRollScore = score
	
	GlobalController.preFinalScore = currentRollScore
	
	GlobalController.applyRoundEndScoreModifiers()
