## Handles creating resources. 
@tool
class_name SeravatManager extends VBoxContainer

const ingPath = preload("res://DataTypes/Ingredients/Ingredient.gd")
const ordPath = preload("res://DataTypes/Order/Order.gd")
const ingOutPath = "res://Data/Ingredients/"
const ordOutPath = "res://Data/Orders/"

var ingText : String = "New Ingredient [%3d]"
var ordText : String = "New Order [%3d]"

var resourceData : ResourceData
@onready var ing_button = $ingBox/ingButton
@onready var ord_button = $ordBox/ordButton
@onready var ing_text = $ingBox/ingText
@onready var ord_text = $ordBox/ordText

func _ready():
	resourceData = ResourceLoader.load("res://addons/resource_manager/resourceData.tres")
	update_button_labels()

## Updates the button labels with the current ID (next). 
func update_button_labels() -> void: 
	ing_button.text = ingText % resourceData.ingID
	ord_button.text = ordText % resourceData.orderID
	
## Set up parent's functionality for this component. 
func setup_parent():
	pass


func _on_ing_button_pressed():
	## TODO Create new Ingredient
	var newIngredient = ingPath.new()
	var ingName : String = ing_text.text + "_" + str(resourceData.ingID)
	newIngredient.Amount = 0
	newIngredient.ID = resourceData.ingID
	resourceData.ingID += 1
	#ResourceSaver.save(newIngredient, ingPath + ingName + ".tres")
	## TODO FIX THIS
	update_button_labels()


func _on_ord_button_pressed():
	## TODO create new Order
	update_button_labels()

func _exit_tree():
	ResourceSaver.save(resourceData, "res://addons/resource_manager/resourceData.tres")
