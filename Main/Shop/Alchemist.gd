extends TextureRect

@export var AlchemistImageStage0 : Texture
@export var AlchemistImageStage1 : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = AlchemistImageStage0

func _on_closet_hunger_changed(new_value):
	match (new_value):
		0:
			self.texture = AlchemistImageStage0
		1,2,3:
			self.texture = AlchemistImageStage1
