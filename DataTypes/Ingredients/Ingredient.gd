## Ingredient class. Handled by the Ingredient Storage and Runners. 
class_name Ingredient extends Resource

@export var Name : String					## Name of the Ingredient
@export var ID : int						## ID  of Ingredient
@export_range(0, 999, 1) var Amount : int	## Amount of Ingredient

@export_group("Processing")
@export var completedFlag : bool = false 	## TRUE if the ingredient is part of an order and it's been completed. 


## Adds to an Ingredient.
func add_amount(added : int) -> void:
	self.Amount += added
	if self.Amount > Globals.MAX_INGREDIENTS:
		self.Amount = Globals.MAX_INGREDIENTS

## Subtracts from an Ingredient. Returns a leftover value. 
func subtract_amount(subtracted : int) -> int:
	var leftover : int = 0
	self.Amount -= subtracted
	if self.Amount < 0: 
		leftover = abs(self.Amount)
		self.Amount = 0
		## TODO: implement item destruction
	return leftover

