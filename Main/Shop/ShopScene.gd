## This scene handles all shop processing. 
class_name ShopScene extends Node

const loseScreen : PackedScene = preload("res://UI/LoseScreen/LoseScreen.tscn")
const sParticles : PackedScene = preload("res://UI/ShadowParticles/ShadowParticles.tscn")

const WORRIED_SOUNDS = [
	preload("res://audio/sfx/alchemist/alchemist_worried_1.ogg"),
	preload("res://audio/sfx/alchemist/alchemist_worried_2.ogg")
]

@onready var dude_manager = $UINodes/DudeManager
@onready var order_manager = $UINodes/OrderManager
@onready var closet = $UINodes/Closet
@onready var storage = $ProcessingNodes/Storage
@onready var introduction_point = $"2DNodes/IntroductionPoint"
@onready var shelves: Shelves = $UINodes/Shelves
@onready var game_timer: GameTimer = $UINodes/GameTimer
@onready var shadometer = $UINodes/Shadometer
@onready var runner = $UINodes/Runner

@onready var processing_nodes: Node = $ProcessingNodes
@onready var ui_nodes: Control = $UINodes
@onready var _2d_nodes: Node2D = $"2DNodes"

@onready var shop_sfx = $ShopSfx
@onready var shop_music = $ShopMusic

func start():
	set_initial_resources()
	setup_timer()
	closet.initialize_closet()
	#closet.reset_hunger_timer()
	dude_manager.begin_spawning_dudes()
	shop_music.play()

## Call to reset and start the game timer. 
func setup_timer():
	game_timer.reset()
	game_timer.start()
	
## Apply initial values to resources. 
func set_initial_resources():
	#storage.add_shadow(100)
	storage.set_ingredients(shelves.get_ingredient_nodes())
	storage.zero_out_ingredients()

## Functional test, no longer implemented. 
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
	dude_manager.stop_spawning_dudes()
	var newScreen = loseScreen.instantiate()
	ui_nodes.add_child(newScreen)
	newScreen.connect("play_again", Callable(get_parent(), "_on_game_restart"))
	newScreen._on_lose(game_timer.get_time_elapsed())
	shop_music.stop()

## Called when a held ingredient is released. 
func _on_shelves_released_ingredient(ingredient : IngredientInventory):
	if closet.get_hovered():
		# Send Ingredients to Closet-kun.
		closet.feed_ingredients(ingredient)
	else:
		# Check for an order being hovered. 
		var currentOrder : OrderFull = order_manager.get_focused_order()
		if currentOrder == null:
			# No current order being hovered. Return. 
			return
		else:
			currentOrder.fill_ingredient(ingredient)

## Called when shadow is earned via an order completing successfully. 
func _on_shadow_earn(amt : int, orderNode : OrderUi) -> void:
	var new_shadow : ShadowParticles = sParticles.instantiate()
	_2d_nodes.add_child(new_shadow)
	new_shadow.spawn_particles(orderNode.global_position, shadometer.get_particle_destination(), amt)

## Queue the alchemist speaking after closet-kun makes a noise. 
func _on_closet_audio_finished():
	if closet.hungerStage == Closet.HUNGER_STAGES.THIRD:
		shop_sfx.stream = load("res://audio/sfx/alchemist/alchemist_scared.ogg")
	else:
		shop_sfx.stream = WORRIED_SOUNDS.pick_random()
	shop_sfx.play()

## Handle leveling up the runner. 
func _on_runner_runner_level_up():
	var newShadow = runner.handle_level_up(storage.get_shadometer())
	if storage.get_shadometer() != newShadow:
		storage.set_new_shadow(newShadow)
