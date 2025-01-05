extends RigidBody3D

@export var sideContainer : Node3D

@export var audioPlayer : AudioStreamPlayer3D

var currentRollValue : int

signal done_rolling

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
			#Put call for unique side properties here
		
		printRollResult()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if(!audioPlayer.get_playback_position() > 0):
		audioPlayer.play()
