extends SideEffect

var multAmount : int = 2

func createSideEffect():
	
	print("Created side effect")
	effectCallable = Callable(
		func():
			diceParent.scoreVisualEffect()
			return GlobalController.preFinalScore * multAmount
	)
