extends Label3D

@export var effectResources : ResourcePreloader

var effectCallableArray := []

var multAmount : int = 2

func _ready() -> void:
	
	instantiateEffectCallables()
	
func instantiateEffectCallables():
	
	for i in effectResources.get_resource_list():
		
		var effect_instance = effectResources.get_resource(i)
		
		print(effect_instance)
		
		effect_instance = effect_instance.new()
		
		effect_instance.multAmount = multAmount
		
		effectCallableArray.append(effect_instance.effectCallable)
