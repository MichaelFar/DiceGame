extends SideEffect

func createSideEffect():
	print("Created side effect")
	
	effectCallable = Callable(func():return GlobalController.preFinalScore * multAmount)
