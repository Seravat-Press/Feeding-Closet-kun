## Ingredient class. Handled by the Ingredient Storage and Runners. 
class_name IngredientInventory extends Resource

signal ingredient_updated

@export var ingredientData : Ingredient		## Base ingredient that this resource leverages. 
@export_range(0, Globals.MAX_INGREDIENTS, 1) var amountHeld : int	## Amount of Ingredient

## Option to pass in a new ingredient on creation. 
func _init(newIngredient : Ingredient = null):
	if newIngredient != null:
		ingredientData = newIngredient

func get_ingredient_name() -> String:
	return ingredientData.Name

func get_tex() -> String:
	return ingredientData.imgRect

func get_id() -> int:
	return ingredientData.ID
	
## Adds to an Ingredient.
func add_amount(added : int) -> void:
	self.Amount += added
	if self.Amount > Globals.MAX_INGREDIENTS:
		self.Amount = Globals.MAX_INGREDIENTS
	emit_signal("ingredient_updated")

## Subtracts from an Ingredient. Returns a leftover value. 
func subtract_amount(subtracted : int) -> int:
	var leftover : int = 0
	self.amountHeld -= subtracted
	if self.amountHeld < 0: 
		leftover = abs(self.amountHeld)
		self.amountHeld = 0
	emit_signal("ingredient_updated")
	return leftover

## Called to update an amountHeld. 
func update_amount(newAmount : int) -> void: 
	amountHeld = newAmount
	emit_signal("ingredient_updated")
