## Base Ingredient Class to be leveraged by other classes. 
class_name Ingredient extends Resource

@export var Name : String					## Name of the Ingredient
@export var ID : int						## ID  of Ingredient
@export_file("*.png") var imgRect			## Icon for this ingredient. 

@export_group("Modifiers")
@export_range(0.01, 20.0, 0.01) var orderTimeMod : float = 0.01	## Modifier for amt of time per 1 in order
@export_range(1, 40, 1) var orderCostMod : int = 1		## Modifier for amt cs per 1 in order
@export_range(0.01, 20.0, 0.01) var fetchTimeMod : float = 0.01	## Modifier for amt of time per 1 in fetch

