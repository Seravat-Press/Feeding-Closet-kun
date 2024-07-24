## This is a Dude
class_name Dude extends Node2D

@export var dudeTexture : Texture
@export var order : OrderFull
@export var dudeName : String

func setup(createDudeName : String, createTexture : Texture, createOrder : OrderFull):
	dudeName = createDudeName
	dudeTexture = createTexture
	order = createOrder

# Called when the node enters the scene tree for the first time.
func _ready():
	var dude_image = $DudeImage
	dude_image.texture = dudeTexture
	print(dudeName + " has spawned in!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Called when an orderUI emit("order_failed") for this dude's order. 
func _on_dudes_order_failed() -> void: 
	print(dudeName + " is so sad their order is failed...")

## Called when an orderUI emit("order_completed") for this dude's order.
func _on_dudes_order_success() -> void:
	print(dudeName + " is so HAPPY their order is fulfilled!")
