extends "res://scripts/SideEffects/side_effect.gd"

func createSideEffect():
	
	effectCallable = Callable(func():GlobalController.preFinalScore * multAmount)
