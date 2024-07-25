## This is a Dude
class_name Dude extends Control

@export var dudeTexture : Texture
@export var order : OrderFull
@export var dudeName : String
@onready var placeholder = $VBoxContainer/DudeImage/Placeholder
@onready var dude_image = $VBoxContainer/DudeImage
@onready var name_label = $VBoxContainer/Label

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Called when an orderUI emit("order_failed") for this dude's order. 
func _on_dudes_order_failed(order : OrderFull) -> void: 
	print(dudeName + " is so sad their order is failed...")

## Called when an orderUI emit("order_completed") for this dude's order.
func _on_dudes_order_success(order : OrderFull) -> void:
	print(dudeName + " is so HAPPY their order is fulfilled!")
