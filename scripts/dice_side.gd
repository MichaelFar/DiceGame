extends Label3D

@export var effectResources : ResourcePreloader

@export var sideValue  : int :
	
	set(value):
		
		sideValue = value
		
		if(value > 0):
		
			text = str(value)

var diceParent : RigidBody3D

var effectCallableArray := []

func _ready() -> void:
	
	diceParent = owner
	
	instantiateEffectCallables()

func setLabelText():
	pass

func instantiateEffectCallables():
	
	for i in effectResources.get_resource_list():
		
		var effect_instance = effectResources.get_resource(i)
		
		print(effect_instance)
		
		effect_instance = effect_instance.new()
		
		effect_instance.diceParent = diceParent
		
		effectCallableArray.append(effect_instance.effectCallable)

func upgradeSide():
	
	var isNormalSide := true
	
	for i in effectCallableArray:
		
		isNormalSide = false
		i.upgrade()
		
	if(isNormalSide):
		
		sideValue += 1
