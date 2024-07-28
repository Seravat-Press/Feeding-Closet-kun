## This is the wrapper node around OrderData. It handles timing and order vars. 
## This is managed by TODO something???
class_name OrderUi extends MarginContainer

const INGREDIENT_LINE = preload("res://UI/Orders/IngredientLine.tscn")

const EASY_COLOR : Color = Color(0.361, 0.631, 0.377, 0.565)
const MED_COLOR : Color = Color(0.653, 0.54, 0.312, 0.565)
const HARD_COLOR : Color = Color(0.811, 0.414, 0.497, 0.565)

signal entered_order(order)
signal left_order(order)

@export var orderData : OrderFull		## Data for this order. 

@onready var order_timer = $OrderTimer
@onready var order_tex: TextureRect = $MarginContainer/VBoxContainer/OrderTex
@onready var ingredient_lines: VBoxContainer = $MarginContainer/VBoxContainer/IngredientLines
@onready var order_progress_bar = $MarginContainer/VBoxContainer/OrderProgressBar
@onready var order_name = $MarginContainer/VBoxContainer/OrderName
@onready var order_outline: ColorRect = $OrderOutline

var outlineEntered : bool = false
var rollingCost : int = 0
var rollingTime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	order_timer.one_shot = true
	order_timer.autostart = false
	order_progress_bar.value = 100

func _process(_delta) -> void: 
	if !order_timer.is_stopped():
		order_progress_bar.value = (order_timer.time_left / self.rollingTime) * 100
	else:
		order_progress_bar.value = 0

## Activate an order and fill out the OrderUI
func activate_order() -> void:
	order_name.text = "[center]" + orderData.get_order_name() + "[/center]"
	order_tex.texture = load(orderData.orderData.imgRect)
	orderData.connect('order_updated', Callable(self, "_on_order_updated"))
	orderData.connect('order_completed', Callable(self, "_on_order_success"))
	
	## Update the frame color
	set_frame_color(orderData.get_order_difficulty())
	
	## Initialize Cost and Time.
	rollingCost = orderData.get_cost_adder()
	rollingTime = orderData.get_time_adder()
	
	var newIngredientLine : IngredientLine
	
	# Loop through ingredients and set up the recipe.
	for ingredient in orderData.get_ingredients():
		# Update rolling counts for cost and time
		rollingTime += ingredient.amountNeeded * ingredient.get_ingredient_order_time_mod()
		rollingCost += ingredient.amountNeeded * ingredient.get_ingredient_order_cost_mod()
		
		newIngredientLine = INGREDIENT_LINE.instantiate()
		
		ingredient_lines.add_child(newIngredientLine)
		# Connect signals for this ingredient
		ingredient.connect("ingredient_updated", Callable(newIngredientLine, "_on_ingredient_updated"))
		newIngredientLine.install_ingredient(ingredient)
	
	order_timer.wait_time = rollingTime
	self.visible = true
	start_order_timer()

## Set the frame color based on the order difficulty. 
func set_frame_color(orderDifficulty : int):
	match (orderDifficulty):
		0: 
			## Simple
			order_outline.material.set_shader_parameter("inside_color", EASY_COLOR)
		1:
			## Intermediate
			order_outline.material.set_shader_parameter("inside_color", MED_COLOR)
		2:
			## Complex
			order_outline.material.set_shader_parameter("inside_color", HARD_COLOR)
	
## Installs an order in this node and sets up the timer. 
func install_order_data(newData : OrderFull) -> void:
	orderData = newData
	orderData.parentUI = self
		
## Start the order timer with the order's wait time. 
func start_order_timer() -> void: 
	order_timer.start()
	
func _on_order_timer_timeout():
	# Order Ran Out
	_on_order_failed()

## Calculates the tip based on the time left when an order is completed. 
#func calculate_tip():
#	## TODO: Do something with this value. Maybe set a threshold of 40% for earning any tip? 
#	var tip = order_timer.time_left / orderData.orderTime

	
func _on_order_outline_mouse_entered():
	outlineEntered = true
	emit_signal("entered_order", self)


func _on_order_outline_mouse_exited():
	outlineEntered = false
	emit_signal("left_order", self)

func _on_order_updated(ingredientChanged : IngredientOrder) -> void:
	## One of the ingredients is completed. 
	print("Completed: " + ingredientChanged.get_ingredient_name() + " in " + orderData.get_order_name())
	if are_ingredients_filled():
		print("This order is complete!")
		orderData.succeed_order()
	else:
		print("There are still ingredients to go!")

## Returns whether or not all ingredients are filled. 
func are_ingredients_filled() -> bool:
	for ingredient in orderData.get_ingredients():
		if ingredient.completedFlag != true:
			return false
	return true

## Returns the current rolling cost for the order. 
func get_cost() -> int:
	return self.rollingCost

## Make the order fall on a fail. 
func order_fall() -> void:
	order_outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fallTween = create_tween()
	var rotTween = create_tween()
	order_outline.position -= Vector2(self.size.x /2, self.size.y / 2)
	$MarginContainer.position -= Vector2(self.size.x /2, self.size.y / 2)
	fallTween.tween_property(self, "position", Vector2(self.position.x, self.position.y + 500), 0.3).set_ease(Tween.EASE_IN)
	
	rotTween.tween_property(self, "rotation", -90, 0.3).set_ease(Tween.EASE_IN)
	
	await fallTween.finished
	queue_free()
	
## Order has failed so remove it and make it fall. 
func _on_order_failed():
	orderData.fail_order()
	order_fall()

## Order succeeded so free he instance. 
func _on_order_success(_orderCompleted : OrderFull):
	queue_free()


func _on_order_outline_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			# Right Mouse Clicked on Order - cancel it
			_on_order_failed()
