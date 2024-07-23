## Ingredient as it sits on a shelf. 
class_name IngredientUI extends Control

@export var ingredientData : Ingredient		## Data for this order. 
@onready var ing_name: Label = $IngName
@onready var ing_count: Label = $IngCount
@onready var full_tex: TextureRect = $FullTex
@onready var hazy_tex: TextureRect = $HazyTex

## Installs an Ingredient into this node. 
func install_ingredient_data(newData : Ingredient) -> void:
	ingredientData = newData
	ing_name.text = ingredientData.Name
	ing_count.text = str(ingredientData.Amount)
