extends Decal

@export var sideValueText : String

@export var label : Label

@export var subViewPort : SubViewport

func _ready():
	
	updateDecal()
	

func updateDecal():
	
	label.text = sideValueText
	var new_texture = ViewportTexture.new()
	new_texture.viewport_path = get_path_to(subViewPort)
	texture_albedo = new_texture
