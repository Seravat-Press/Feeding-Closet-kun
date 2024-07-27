## Handle an order with Ingredient needs. 
class_name OrderFull extends Resource

signal order_updated(ingredient_finished)
signal order_completed
signal order_failed

@export var orderData : Order				## Order that this full order utilizes. 
@export_range(-30.0,30.0, 0.1) var timeAdder : float = 0.0		## Adder to calculated order time.
@export_range(-10, 40, 1) var costAdder : int = 0				## Adder to calculated cost. 

var parentUI : OrderUi

func new_instance():
	var instance = self.duplicate(true)
	instance.orderData.fix_ingredients()
	return instance

## Returns the cost adder of this order. 
func get_cost_adder() -> int:
	return self.costAdder

## Returns the time adder of this order. 
func get_time_adder() -> float:
	return self.timeAdder
	
func set_order_data(newOrder : Order) -> void: 
	self.orderData = newOrder

func get_ingredients() -> Array[IngredientOrder]:
	return orderData.get_ingredients()

func get_order_name() -> String:
	return orderData.Name
	
## Fill an ingredient in the order.
func fill_ingredient(new_ingredient : IngredientInventory) -> void:
	for ingred in orderData.get_ingredients():
		if (ingred.ingredientData.ID == new_ingredient.get_id()) and (ingred.completedFlag == false):
			## TODO: This could be a dict with the IDs as the keys, no more looping
			
			# Make the Amount the leftover. 
			new_ingredient.update_amount(ingred.fill_amount(new_ingredient.amountHeld))
			new_ingredient.emit_signal("ingredient_updated")
			
			# If the ingredient is filled, send a message. 
			if ingred.amountNeeded == 0:
				ingred.completedFlag = true
				emit_signal("order_updated", ingred)

func get_order_data() -> Order:
	return orderData
	
func fail_order() -> void:
	emit_signal("order_failed", self)

func succeed_order() -> void: 
	emit_signal("order_completed", self)
