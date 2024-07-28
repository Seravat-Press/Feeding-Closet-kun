## This is a Dude
class_name Dude extends Control

@export var dudeTexture : Texture
@export var order : OrderFull
@export var dudeName : String
@onready var placeholder = $Placeholder
@onready var dude_image = $DudeImage
@onready var name_label = $Label

func setup(createDudeName : String, createTexture : Texture, createOrder : OrderFull):
	dudeName = createDudeName
	dudeTexture = createTexture
	order = createOrder

# Called when the node enters the scene tree for the first time.
func _ready():
	placeholder.visible = false
	dude_image.texture = dudeTexture
	name_label.text = dudeName
	print(dudeName + " has spawned in!")

## Called when an orderUI emit("order_failed") for this dude's order. 
func _on_dudes_order_failed(_failed_order : OrderFull) -> void: 
	print(dudeName + " is so sad their order is failed...")
	Globals.get_score_manager().add_sad_person(self.dudeName)

## Called when an orderUI emit("order_completed") for this dude's order.
func _on_dudes_order_success(_success_order : OrderFull) -> void:
	print(dudeName + " is so HAPPY their order is fulfilled!")
	Globals.get_score_manager().add_happy_person(self.dudeName)
