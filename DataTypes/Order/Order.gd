## Handle an order with Ingredient needs. 
class_name Order extends Resource

@export var Name : String					## Name of Ingredients
@export var Ingredients : Array[Ingredient]	## Array of Ingredients
@export var orderTime : float = 1.00		## Total time in the order
@export var cost : int = 0					## Cost of the order
@export_file("*.png") var imgRect			## Icon for this Order.
 
@export_group("Don't Change")
@export var ID : int

## TODO predicate array of strings

## Fill an ingredient in the order.
func fill_ingredient(new_ingredient : Ingredient) -> void:
	for ingred in Ingredients:
		if (ingred.ID == new_ingredient.ID) and (ingred.completedFlag == false):
			## TODO: This could be a dict with the IDs as the keys, no more looping
			
			# Make the Amount the leftover. 
			new_ingredient.Amount = ingred.subtract_amount(new_ingredient.Amount)
			
			# If the ingredient is filled, send a message. 
			if ingred.Amount == 0:
				ingred.completedFlag = true
				print("Ingredient Filled!")
