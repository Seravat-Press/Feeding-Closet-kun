## UI Line for each Ingredient in a recipe. Hidden when the ingredient is completed. 
class_name IngredientLine extends Control

@onready var ing_tex: TextureRect = $IngredientData/IngTex
@onready var ing_name: Label = $IngredientData/IngName
@onready var ing_count: Label = $IngredientData/IngCount
@onready var done_line = $DoneLine

func _ready():
	done_line.visible = false
	
## Set up the scene data with all of the ingredient data. 
func install_ingredient(ingredientData : IngredientOrder):
	ing_tex.texture = load(ingredientData.ingredientData.imgRect)
	ing_name.text = ingredientData.ingredientData.Name
	ing_count.text = str(ingredientData.amountNeeded)

## When the ingredient completes, turn off this scene. 
func _on_ingredient_complete():
	done_line.visible = true

## Update the Ingredient UI based on the ingredient data changed. 
func _on_ingredient_updated(newIng : IngredientOrder) -> void:
	ing_count.text = str(newIng.amountNeeded)
	if newIng.amountNeeded == 0:
		done_line.visible = true
