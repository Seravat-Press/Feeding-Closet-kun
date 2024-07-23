class_name RequestIngredientButton extends Button

@export var ingredient : Ingredient

signal ingredient_clicked(ingredient)

func _on_button_up():
	print("Ingredient request button clicked.")
	ingredient_clicked.emit(ingredient)
