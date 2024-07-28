class_name OrderManager extends Control

const SIMPLE_ORDERS = "res://Data/Orders/Simple/"
const INT_ORDERS	= "res://Data/Orders/Intermediate/"
const COMP_ORDERS  = "res://Data/Orders/Complex/"

## Weights for random orders. 
const STARTER_WEIGHTS : Array[float] = [
	0.75,	## Simple
	0.25,	## Intermediate
	0.0		## Complex
]

## Weights for random orders. 
const MIDDLE_WEIGHTS : Array[float] = [
	0.4,	## Simple
	0.5,	## Intermediate
	0.1		## Complex
]

## Weights for random orders. 
const END_WEIGHTS : Array[float] = [
	0.2,	## Simple
	0.4,	## Intermediate
	0.4		## Complex
]

signal add_shadow(amt : int, orderui : OrderUi)
signal queued_order_failed

var orderQueue : Array
var newOrderPreloaded = preload("res://UI/Orders/OrderUI.tscn")
var orderDifficultyStage : int = 0

const BOTTLE_SOUNDS = [
	preload("res://audio/sfx/bottle_1.ogg"),
	preload("res://audio/sfx/bottle_2.ogg"),
	preload("res://audio/sfx/bottle_3.ogg")]
const FAIL_SOUND = preload("res://audio/sfx/order_fail.ogg")


@onready var visual_queue = $ScrollContainer/VisualQueue
@onready var visual = $Visual
@onready var order_audio = $OrderAudio

var focusedOrder : OrderUi

# Order Arrays
var simpleArray : Array[OrderFull]
var intArray : Array[OrderFull]
var compArray : Array[OrderFull]

# Called when the node enters the scene tree for the first time.
func _ready():
	visual.visible = false
	build_order_arrays()

## Returns an instance of a random OrderFull based on the timing/random weights. 
func get_random_order_instance() -> OrderFull:
	var randValue : float = randf_range(0.0, 1.0)
	var currentWeights : Array[float]
	
	## Check difficulty stage for weights. 
	match (orderDifficultyStage):
		0:
			currentWeights = STARTER_WEIGHTS
		1:
			currentWeights = MIDDLE_WEIGHTS
		2: 
			currentWeights = END_WEIGHTS
	
	## Check weights against the random value. 
	if randValue < currentWeights[0]:
		## Queue Simple Order
		return simpleArray.pick_random().new_instance()
	elif randValue < (currentWeights[0] + currentWeights [1]):
		## Return Intermediate Order
		return intArray.pick_random().new_instance()
	## Return Complex Order
	return compArray.pick_random().new_instance()
	
## Build all of the order arrays
func build_order_arrays():
	var newOrder : OrderFull
	
	# Simple Orders
	var orderFilesArray = Globals.list_files_in_directory(SIMPLE_ORDERS)
	for orderFile in orderFilesArray:
		newOrder = ResourceLoader.load(orderFile)
		simpleArray.append(newOrder)
	
	# Intermediate Orders
	orderFilesArray = Globals.list_files_in_directory(INT_ORDERS)
	for orderFile in orderFilesArray:
		newOrder = ResourceLoader.load(orderFile)
		intArray.append(newOrder)
	
	# Complex Orders
	orderFilesArray = Globals.list_files_in_directory(COMP_ORDERS)
	for orderFile in orderFilesArray:
		newOrder = ResourceLoader.load(orderFile)
		compArray.append(newOrder)
		
func generate_order(orderData):
	var newOrder : OrderUi = newOrderPreloaded.instantiate()
	newOrder.install_order_data(orderData)
	order_enqueue(newOrder)

func order_enqueue(newOrder : OrderUi):
	newOrder.connect("entered_order", Callable(self,"_on_order_focused"))
	newOrder.connect("left_order", Callable(self,"_on_order_unfocused"))
	visual_queue.add_child(newOrder)
	newOrder.orderData.connect("order_completed", Callable(self, "_on_order_success"))
	newOrder.orderData.connect("order_failed", Callable(self, "_on_order_fail"))
	newOrder.activate_order()
	orderQueue.append(newOrder)

func _on_shop_devoured() -> void:
	for order in visual_queue.get_children():
		order._on_order_failed()

func order_dequeue():
	visual_queue.remove_child(orderQueue.pop_front())

## When a dude is spawned, attach its order to the queue
func _on_dude_manager_dude_spawned(dude):
	generate_order(dude.order)

## IngredientUI emits signal for "picked_up" and passes itself. 
func _on_order_focused(inOrder : OrderUi) -> void:
	focusedOrder = inOrder

## IngredientUI emits signal for "released" and passes itself.
func _on_order_unfocused(outOrder : OrderUi) -> void:
	if focusedOrder == outOrder:
		focusedOrder = null

func get_focused_order() -> OrderFull:
	if focusedOrder != null:
		return focusedOrder.orderData
	else:
		return null

func _on_order_success(orderWin : OrderFull) -> void:
	emit_signal("add_shadow", orderWin.parentUI.get_cost(), orderWin.parentUI)
	order_audio.stream = BOTTLE_SOUNDS.pick_random()
	order_audio.play()

func _on_order_fail(_order_fail : OrderFull) -> void:
	#order_audio.stream = FAIL_SOUND
	#order_audio.play()
	## Took out fail noise because it made me sad
	emit_signal("queued_order_failed")

## Increment order difficulty after an increment.
func _on_game_timer_increment_reached():
	if orderDifficultyStage < 2:
		## Only increase to 2. 
		orderDifficultyStage += 1
