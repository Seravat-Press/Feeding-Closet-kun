## This is the wrapper node around OrderData. It handles timing and order vars. 
## This is managed by TODO something???
class_name OrderUi extends Control

const INGREDIENT_LINE = preload("res://UI/Orders/IngredientLine.tscn")

@export var orderData : Order		## Data for this order. 

@onready var order_timer = $OrderTimer
@onready var order_tex: TextureRect = $OrderTex
@onready var ingredient_lines: VBoxContainer = $IngredientLines

# Called when the node enters the scene tree for the first time.
func _ready():
	order_timer.one_shot = true
	order_timer.autostart = false
	
	## If we already have data somehow, set the timer up. 
	if orderData != null: 
		order_timer.wait_time = orderData.orderTime

## Installs an order in this node and sets up the timer. 
func install_order_data(newData : Order) -> void:
	orderData = newData
	order_timer.wait_time = orderData.orderTime
	order_tex.texture = load(orderData.imgRect)
	# TODO Setup signals from order to the UI for when it's complete 
	# or maybe do a check after an ingredient is filled out and check for all. 
	var newIngredientLine
	
	# Loop through ingredients and set up the recipe.
	for ingredient in orderData.Ingredients:
		newIngredientLine = INGREDIENT_LINE.instantiate()
		newIngredientLine.install_ingredient(ingredient)
		
		# Connect signals for this ingredient
		ingredient.connect("ingredient_gone", Callable(newIngredientLine, "_on_ingredient_complete"))
		ingredient_lines.add_child(newIngredientLine)
		
## Start the order timer with the order's wait time. 
func start_order_timer() -> void: 
	order_timer.start()
	
func _on_order_timer_timeout():
	# Order Ran Out
	print("Order Ran Out: " + orderData.Name)

## Calculates the tip based on the time left when an order is completed. 
func calculate_tip():
	## TODO: Do something with this value. Maybe set a threshold of 40% for earning any tip? 
	var tip = order_timer.time_left / orderData.orderTime
