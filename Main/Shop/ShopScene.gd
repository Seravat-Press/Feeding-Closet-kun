## This scene handles all shop processing. 
class_name ShopScene extends Node

@onready var dude_manager = $"2DNodes/DudeManager"
@onready var order_manager = $ProcessingNodes/OrderManager
@onready var closet = $UINodes/Closet
@onready var storage = $ProcessingNodes/Storage

func _ready():
	print("Shop Activated!")
	start_game()
	
func start_game():
	dude_manager.spawn_dude()
	order_manager.generate_order(dude_manager.currentDude.order)
	closet.reset_hunger_timer()
	storage.add_shadow(100)

## Called when all of the hunger thresholds are hit in the closet. 
func _on_closet_shop_devoured():
	# TODO: Serve End Game Scene
	pass # Replace with function body.
