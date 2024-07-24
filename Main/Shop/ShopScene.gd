## This scene handles all shop processing. 
class_name ShopScene extends Node

@onready var dude_manager = $"2DNodes/DudeManager"
@onready var order_manager = $UINodes/OrderManager
@onready var closet = $UINodes/Closet
@onready var storage = $ProcessingNodes/Storage
@onready var introduction_point = $"2DNodes/IntroductionPoint"

func _ready():
	print("Shop Activated!")
	start_game()

func start_game():
	set_initial_resources()
	closet.reset_hunger_timer()
	dude_manager.begin_spawning_dudes()
	#run_test()

func set_initial_resources():
	#storage.add_shadow(100)
	pass

func game_loop():
	# after timer, spawn a dude
	# put order in queue
	# start dude cd timer
	pass

func run_test():
	dude_manager.spawn_dude()
	order_manager.generate_order(dude_manager.currentDude.order)
	closet.reset_hunger_timer()
	
	dude_manager.move_dude(dude_manager.currentDude, introduction_point.position)
	await get_tree().create_timer(5.0).timeout
	dude_manager.despawn_current_dude()
	dude_manager.spawn_dude()
	order_manager.generate_order(dude_manager.currentDude.order)
	dude_manager.move_dude(dude_manager.currentDude, introduction_point.position)
	await get_tree().create_timer(2.0).timeout
	order_manager.order_dequeue()

## Called when all of the hunger thresholds are hit in the closet. 
func _on_closet_shop_devoured():
	# TODO: Serve End Game Scene
	pass # Replace with function body.

## Called when a held ingredient is released. 
func _on_shelves_released_ingredient(ingredient : IngredientInventory):
	var currentOrder : OrderFull = order_manager.get_focused_order()
	if currentOrder == null:
		# No current order being hovered. Return. 
		return
	else:
		currentOrder.fill_ingredient(ingredient)
