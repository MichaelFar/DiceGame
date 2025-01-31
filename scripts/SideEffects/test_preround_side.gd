extends SideEffect

var scoreAmount := 4

func createSideEffect():
	
	print("Created side effect")
	effectCallable = Callable(
		func():
			diceParent.scoreVisualEffect()
			print("Scoring within a SideEffect")
			print("Score adding is " + str(GlobalController.preFinalScore + scoreAmount))
			GlobalController.preFinalScore += scoreAmount
			return 0
	)

func addSideEffectToList():
	
	GlobalController.roundStartCallableArray.append(effectCallable)
