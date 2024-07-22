## Handle an order with Ingredient needs. 
class_name Order extends Resource

@export var Name : String					## Name of Ingredients
@export var Ingredients : Array[Ingredient]	## Array of Ingredients
@export var orderTime : float = 1.00		## Total time in the order

## Fill an ingredient in t
func fill_ingredient(new_ingredient : Ingredient) -> void:
	for ingred in Ingredients:
		if ingred.ID == new_ingredient.ID:
			## TODO: This could be a dict with the IDs as the keys, no more looping
			
			# Make the Amount the leftover. 
			new_ingredient.Amount = ingred.subtract_amount(new_ingredient.Amount)
			
			# If the ingredient is filled, send a message. 
			if ingred.Amount == 0:
				print("Ingredient Filled!")

