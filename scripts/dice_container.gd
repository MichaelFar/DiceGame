extends Node3D

@export var scoreLabel : Label

@export var targetLabel : Label

@export var cashLabel : Label

@export var cashOutButton : Button

@export var diceResources : ResourcePreloader

@export var diceParent : Node3D

@export var spawnPoints : Node3D

@export var soundContainer : Node3D

@export var currentRollLabel : Label

@export var cashoutSound : AudioStreamPlayer3D

var diceArray := []

var canRoll = true

var hasRolledOnce = false

var isRolling := false

var currentRollScore := 0

func _ready():
	
	GlobalController.scoreLabel = scoreLabel
	
	GlobalController.cashLabel = cashLabel
	
	GlobalController.cashOutButton = cashOutButton
	
	GlobalController.diceContainer = self
	
	GlobalController.soundContainer = soundContainer
	
	GlobalController.currentRollLabel = currentRollLabel
	
	GlobalController.targetLabel = targetLabel
	
	GlobalController.currentScoreTarget = 6
	
	cashLabel.text = "Cash: " + str(GlobalController.playerCash)
	
	populateDice()

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_released("debug")):
		
		endRound()
		
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
	
	isRolling = true
	
	for i in diceArray:
		
		i.rollDice()

func checkForDuplicateNumbersThenScore():
	
	var value_array = []
	
	var scored_dice_array = []
	
	var score := 0
	
	var previous_number_array = []
	
	GlobalController.isScoring = true
	
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
	#If no duplicates are found, score the highest number
	if(score == 0):
		
		scored_dice_array.append(diceArray[value_array.find(value_array.max())])
		
		score += value_array.max()
	
	for i in scored_dice_array:
		
		var tween = get_tree().create_tween()
		
		tween.tween_property(scoreLabel,"text", "Score: " + str(int(scoreLabel.text) + i.rolledSide.sideValue), .4)
		
		i.scoreVisualEffect()
		
		await tween.finished
		
		await i.done_scoring
		
	canRoll = true
	
	currentRollScore = score
	
	GlobalController.preFinalScore = currentRollScore
	
	
	
	currentRollLabel.text = "This Roll: " + str(currentRollScore) 
	
	GlobalController.applyRoundEndScoreModifiers()
	await GlobalController.finished_round_end
	currentRollLabel.text = "This Roll: " + str(GlobalController.currentRollScore)

func endRound():
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(diceParent, "scale", Vector3.ZERO, 1.0)
	
	await tween.finished
	
	for i in diceParent.get_children():
		i.queue_free()

func _on_button_mouse_entered() -> void:

	canRoll = false

func _on_button_mouse_exited() -> void:

	if(!GlobalController.isScoring && !isRolling):
		
		canRoll = true
	

func _on_button_button_down() -> void:
	
	if(!GlobalController.isScoring):
		
		GlobalController.playerCash += GlobalController.totalScore / 5
		
		GlobalController.totalScore = 0
		
		cashoutSound.play()
		
		cashOutButton.text = "Click to Cash Out For: \n" + str(0)
	
	#endRound()
