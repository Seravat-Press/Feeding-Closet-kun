## This is a Dude
class_name Dude extends Node2D

@export var sprite : Sprite2D
@export var order : Order
@export var dudeName : String

@onready var sprite_2d = $Sprite2D

func _init(createDudeName : String, createSprite : Sprite2D, createOrder : Order):
	dudeName = createDudeName
	sprite_2d.texture = createSprite
	order = createOrder

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
