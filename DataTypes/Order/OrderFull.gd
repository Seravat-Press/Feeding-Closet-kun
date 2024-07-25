## Handle an order with Ingredient needs. 
class_name OrderFull extends Resource

signal order_updated(ingredient_finished)
signal order_completed
signal order_failed

@export var orderData : Order				## Order that this full order utilizes. 
@export var orderTime : float = 1.00		## Total time in the order
@export var cost : int = 0					## Cost of the order

var parentUI : OrderUi

func new_instance():
	var instance = self.duplicate(true)
	instance.orderData.fix_ingredients()
	return instance

func get_cost() -> int:
	return self.cost
	
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
