## Base Order class w/ basic ingredient values. 
class_name Order extends Resource

signal order_updated(ingredient_finished)

enum ORDER_DIFFICULTY {
	SIMPLE = 0,
	INTERMEDIATE,
	COMPLEX
}

@export var Name : String					## Name of order
@export var neededIngredients : Array[IngredientOrder]	## Array of Ingredients
@export_file("*.png") var imgRect			## Icon for this Order.
@export var difficulty : ORDER_DIFFICULTY = ORDER_DIFFICULTY.SIMPLE

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

## Return the difficulty of this order. 
func get_difficulty() -> ORDER_DIFFICULTY:
	return self.difficulty
