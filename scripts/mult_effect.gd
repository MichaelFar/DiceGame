extends Node

@export var multAmount : int

var effectCallable : Callable

func _ready() -> void:
	
	multScore()

func multScore() -> int:
	print("Multing")
	effectCallable = 
	return GlobalController.preFinalScore * multAmount
