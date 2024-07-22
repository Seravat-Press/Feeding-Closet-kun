## This is a Dude
class_name Dude extends Node2D

@export var dudeTexture : Texture
@export var order : Order
@export var dudeName : String

func setup(createDudeName : String, createTexture : Texture, createOrder : Order):
	dudeName = createDudeName
	dudeTexture = createTexture
	order = createOrder

# Called when the node enters the scene tree for the first time.
func _ready():
	var dude_image = $DudeImage
	dude_image.texture = dudeTexture
	print(dudeName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
