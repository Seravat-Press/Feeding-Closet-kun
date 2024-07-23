## The main game module. Grabs different scenes. 
class_name Main extends Node

@onready var dude_manager = $DudeManager
@onready var closet_timer = $Closet/HungerTimer
@onready var closet = $Closet
@onready var storage = $Storage
@onready var order_manager = $OrderManager

@onready var shopScene : ShopScene = load("res://Main/Shop/ShopScene.tscn").instantiate()

var currentScene : Node

func _ready():
	print("Welcome to the game!")
	currentScene = shopScene
	add_child(currentScene)
