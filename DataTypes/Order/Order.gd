## Base Order class w/ basic ingredient values. 
class_name Order extends Resource

signal order_updated(ingredient_finished)

@export var Name : String					## Name of order
@export var neededIngredients : Array[IngredientOrder]	## Array of Ingredients
@export_file("*.png") var imgRect			## Icon for this Order.
 
@export_group("Don't Change")
@export var ID : int

var realIngredients : Array[IngredientOrder]
## TODO predicate array of strings

## This function resolves an issue with arrays of resources. 
## NOTE This is an ERRATA in Godot 4.2.2 and should be resolved in 4.3. 
func fix_ingredients() -> void:
	for ing in neededIngredients:
		realIngredients.append(ing.duplicate(true))
	realIngredients.sort_custom(Callable(self, "custom_sort_ing_by_id"))

## Sort the needed ingredients by ID so that they're always in the correct order. 
func custom_sort_ing_by_id(a : IngredientOrder, b : IngredientOrder) -> bool:
	if a.ingredientData.ID <= b.ingredientData.ID:
		return true
	else:
		return false
		
## Returns the array of ingredients. 
func get_ingredients() -> Array[IngredientOrder]:
	return realIngredients
	
## Fill an ingredient in the order.
func fill_ingredient(new_ingredient : IngredientInventory) -> void:
	for ingred in realIngredients:
		if (ingred.ingredientData.ID == new_ingredient.ID) and (ingred.completedFlag == false):
			## TODO: This could be a dict with the IDs as the keys, no more looping
			
			# Make the Amount the leftover. 
			new_ingredient.update_amount(ingred.fill_amount(new_ingredient.amountHeld))
			new_ingredient.emit_signal("ingredient_updated")
			
			# If the ingredient is filled, send a message. 
			if ingred.Amount == 0:
				ingred.completedFlag = true
				emit_signal("order_updated", new_ingredient)
