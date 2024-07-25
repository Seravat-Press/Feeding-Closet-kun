## This scene handles all shop processing. 
class_name ShopScene extends Node

const loseScreen : PackedScene = preload("res://UI/LoseScreen/LoseScreen.tscn")
@onready var dude_manager = $UINodes/DudeManager
@onready var order_manager = $UINodes/OrderManager
@onready var closet = $UINodes/Closet
@onready var storage = $ProcessingNodes/Storage
@onready var introduction_point = $"2DNodes/IntroductionPoint"
@onready var shelves: Shelves = $UINodes/Shelves
@onready var game_timer: GameTimer = $UINodes/GameTimer

@onready var processing_nodes: Node = $ProcessingNodes
@onready var ui_nodes: Control = $UINodes
@onready var _2d_nodes: Node2D = $"2DNodes"

func start():
	set_initial_resources()
	closet.initialize_closet()
	closet.reset_hunger_timer()
	dude_manager.begin_spawning_dudes()
	setup_timer()
	#run_test()

## Call to reset and start the game timer. 
func setup_timer():
	game_timer.reset()
	game_timer.start()
	
func set_initial_resources():
	#storage.add_shadow(100)
	storage.set_ingredients(shelves.get_ingredient_nodes())

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
	Globals.wait(5.0)
	dude_manager.despawn_current_dude()
	dude_manager.spawn_dude()
	order_manager.generate_order(dude_manager.currentDude.order)
	dude_manager.move_dude(dude_manager.currentDude, introduction_point.position)
	Globals.wait(2.0)
	order_manager.order_dequeue()

## Called when all of the hunger thresholds are hit in the closet. 
func _on_closet_shop_devoured():
	game_timer.stop()
	var newScreen = loseScreen.instantiate()
	ui_nodes.add_child(newScreen)
	newScreen.connect("play_again", Callable(get_parent(), "_on_game_restart"))
	newScreen._on_lose(game_timer.get_time_elapsed())

## Called when a held ingredient is released. 
func _on_shelves_released_ingredient(ingredient : IngredientInventory):
	var currentOrder : OrderFull = order_manager.get_focused_order()
	if currentOrder == null:
		# No current order being hovered. Return. 
		return
	else:
		currentOrder.fill_ingredient(ingredient)
