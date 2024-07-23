## Ingredient class. Handled by the Ingredient Storage and Runners. 
class_name Ingredient extends Resource

## Types of Ingredient.
enum INGR_CLASS {
	STORAGE,	## Storage/Runner
	ORDER		## Put in Orders
}

## Signal for when an ingredient runs out. 
signal ingredient_gone
signal ingredient_updated

@export var Name : String					## Name of the Ingredient
@export var ID : int						## ID  of Ingredient
@export_range(0, Globals.MAX_INGREDIENTS, 1) var Amount : int	## Amount of Ingredient
@export_file("*.png") var imgRect			## Icon for this ingredient. 
@export_range(1.0, 30.0, 0.5) var sourceTime : float	## Time taken to get the ingredient.

@export_group("Processing")
@export var completedFlag : bool = false 	## TRUE if the ingredient is part of an order and it's been completed. 
@export var orderPart : INGR_CLASS = INGR_CLASS.STORAGE


## Adds to an Ingredient.
func add_amount(added : int) -> void:
	self.Amount += added
	if self.Amount > Globals.MAX_INGREDIENTS:
		self.Amount = Globals.MAX_INGREDIENTS
	emit_signal("ingredient_updated")

## Subtracts from an Ingredient. Returns a leftover value. 
func subtract_amount(subtracted : int) -> int:
	var leftover : int = 0
	self.Amount -= subtracted
	if self.Amount < 0: 
		leftover = abs(self.Amount)
		self.Amount = 0
		## handle destruction, but NOT when part of an order
	emit_signal("ingredient_updated")
	return leftover

