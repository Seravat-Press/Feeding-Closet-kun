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

## When the new Ingredient button is pressed, create a new Ingredient. 
func _on_ing_button_pressed():
	var newIngredient = ingPath.new()
	var ingNamePath : String = ingOutPath + (str(resourceData.ingID) + "_" + ing_text.text) + ".tres"
	newIngredient.Name = ing_text.text
	newIngredient.Amount = 0
	newIngredient.ID = resourceData.ingID
	resourceData.ingID += 1
	ResourceSaver.save(newIngredient, ingNamePath)
	update_button_labels()
	ing_text.text = ""
	EditorInterface.get_inspector().resource_selected.emit(newIngredient, ingNamePath)

## When the new Order button is pressed, create a new Order. 
func _on_ord_button_pressed():
	var newOrder = ordPath.new()
	var ordNamePath : String = ordOutPath + (str(resourceData.orderID) + "_" + ord_text.text) + ".tres"
	newOrder.Name = ord_text.text
	newOrder.ID = resourceData.orderID
	resourceData.orderID += 1
	ResourceSaver.save(newOrder, ordNamePath)
	update_button_labels()
	ord_text.text = ""
	EditorInterface.get_inspector().resource_selected.emit(newOrder, ordNamePath)

func _exit_tree():
	ResourceSaver.save(resourceData, "res://addons/resource_manager/resourceData.tres")
