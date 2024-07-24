class_name RequestIngredientButton extends Button

@export var ingredient : IngredientFetch

signal ingredient_clicked(ingredient)

func _on_button_up():
	print("Requesting ingredient: " + ingredient.get_ingredient_name())
	ingredient_clicked.emit(ingredient)
