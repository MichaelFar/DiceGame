extends Label3D

@export var effectResources : ResourcePreloader

var effectCallableArray := []

func _ready() -> void:
	
	instantiateEffectCallables()
	
func instantiateEffectCallables():
	
	for i in effectResources.get_resource_list():
		
		var effect_instance = load(i)
		
		effectCallableArray.append(effect_instance.effectCallable)
