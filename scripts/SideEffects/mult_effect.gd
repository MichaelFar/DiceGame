extends SideEffect

var multAmount : int = 2

func createSideEffect():
	
	print("Created side effect")
	effectCallable = Callable(
		func():
			diceParent.scoreVisualEffect()
			print("Multing with: " + str(GlobalController.preFinalScore))
			return GlobalController.preFinalScore * multAmount
	)

func addSideEffectToList():
	
	GlobalController.roundEndCallableArray.append(effectCallable)
