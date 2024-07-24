## Ingredient class for the Runners. Intended to be leveraged from code or the editor. 
class_name IngredientFetch extends Resource

@export var ingredientData : Ingredient		## Base ingredient that this resource leverages. 
@export_range(1.0, 30.0, 0.5) var sourceTime : float	## Time taken to get the ingredient.
@export_range(0, 100, 1) var gatherMin : int = 10 ## Minimum amount gathered by runner
@export_range(0, 100, 1) var gatherMax : int = 10 ## Maximum amount gathered by runner

## Option to pass in a new ingredient on creation. 
func _init(newIngredient : Ingredient = null):
	if newIngredient != null:
		ingredientData = newIngredient

## Set the source time for the gather. 
func set_source_time(newTime : float) -> void: 
	sourceTime = newTime

## Returns a random value to gather. 
func get_random_gather() -> int:
	return randi_range(gatherMin, gatherMax)

func get_ingredient_name() -> String:
	return ingredientData.Name
