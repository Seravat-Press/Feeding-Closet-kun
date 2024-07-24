## Data type for an ingredient as part of an order. 
class_name IngredientOrder extends Resource

signal ingredient_updated(ingredientOrder)

@export var ingredientData : Ingredient		## Base ingredie nt that this resource leverages. 
@export var amountNeeded : int = 1			## Number remaining to fill. 
@export var completedFlag : bool = false 	## TRUE if the ingredient is part of an order and it's been completed. 

## Option to pass in a new ingredient on creation. 
func _init(newIngredient : Ingredient = null):
	if newIngredient != null:
		ingredientData = newIngredient
		
## Subtracts from an IngredientOrder. Returns a leftover value. 
func fill_amount(subtracted : int) -> int:
	var leftover : int = 0
	self.amountNeeded -= subtracted
	if self.amountNeeded < 0: 
		leftover = abs(self.amountNeeded)
		self.amountNeeded = 0
		## handle destruction, but NOT when part of an order
	emit_signal("ingredient_updated", self)
	return leftover

func get_ingredient_name() -> String: 
	return ingredientData.Name
