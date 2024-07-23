## The main game module
class_name Main extends Node

@onready var dude_manager = $DudeManager
@onready var closet_timer = $Closet/HungerTimer
@onready var closet = $Closet
@onready var storage = $Storage
@onready var order_manager = $OrderManager

func _ready():
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
