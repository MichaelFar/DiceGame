extends RigidBody3D

@export var sideContainer : Node3D

@export var audioPlayer : AudioStreamPlayer3D

@export var scoreSoundContainer : Node3D

var currentRollValue : int

signal done_rolling

signal done_scoring

var hasRolledOnce := false

func printRollResult():
	
	print(getRollResult().text)

func getRollResult() -> Label3D:
	
	var current_highest := 0.0
	
	var return_result : Label3D
	
	for i in sideContainer.get_children():
		
		if(current_highest < i.global_position.y):
			
			current_highest = i.global_position.y
			
			return_result = i
			
	return return_result

func rollDice():
	
	hasRolledOnce = true
	
	currentRollValue = 0
	
	var rand_obj := RandomNumberGenerator.new()
	
	var rand_range = rand_obj.randf_range(-1,1)
	
	apply_impulse(Vector3.UP * 10,Vector3(0.5 * rand_range,0.5 * rand_range,0))


func _on_sleeping_state_changed() -> void:
	
	if(is_sleeping() && linear_velocity != Vector3.ZERO):
		
		done_rolling.emit()
		
		if(getRollResult().text.is_valid_float()):
			
			currentRollValue = int(getRollResult().text)
			
		else:
			
			currentRollValue = 0
			
			if(getRollResult().get_script() != null):
				#CHANGE THIS TO NOT BE BAD
				for i in getRollResult().effectCallableArray:
					
					GlobalController.callableArray.append(i)
					
				await GlobalController.finished_round_end
			
				scoreVisualEffect()
		
		printRollResult()

func scoreVisualEffect():
	
	var scored_label = getRollResult()
	
	var tween = get_tree().create_tween()
	
	var tween_back = func():
		
		var tween_2 = get_tree().create_tween()
		
		tween_2.set_trans(Tween.TRANS_SPRING)
		
		tween_2.tween_property(scored_label,"basis",scored_label.basis.rotated(scored_label.basis.z, PI/4), .2)
		
		await tween_2.finished
		
		done_scoring.emit()
		
	var tween_reverse = func():
		
		playRandomScoreSound()
		
		var tween_2 = get_tree().create_tween()
		
		tween_2.finished.connect(tween_back)
		
		tween_2.set_trans(Tween.TRANS_SPRING)
		
		tween_2.tween_property(scored_label,"basis",scored_label.basis.rotated(scored_label.basis.z, -2 * PI/4), .2)
	
	tween.finished.connect(tween_reverse)
	
	tween.set_trans(Tween.TRANS_SPRING)
	
	tween.tween_property(scored_label,"basis",scored_label.basis.rotated(scored_label.basis.z, PI/4), .2)
	
func playRandomScoreSound():
	
	var rand_obj = RandomNumberGenerator.new()
	
	var rand_index = rand_obj.randi_range(0, scoreSoundContainer.get_children().size() - 1)
	
	scoreSoundContainer.get_children()[rand_index].play()

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if(!audioPlayer.get_playback_position() > 0 && hasRolledOnce):
	
		audioPlayer.play()
