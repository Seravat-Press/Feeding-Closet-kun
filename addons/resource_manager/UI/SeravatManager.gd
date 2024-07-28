## Handles creating resources for the Seravat Press Pirate Jam 15 submission. 
@tool
class_name SeravatManager extends VBoxContainer

const ingPath = preload("res://DataTypes/Ingredients/Ingredient.gd")	## Ingredient Resource.
const ordPath = preload("res://DataTypes/Order/Order.gd")				## Order Resource. 
const ingOutPath = "res://Data/IngredientTypes/"						## Output path for ingredients. 
const ordOutPath = "res://Data/OrderTypes/"								## Output path for orders.

var ingText : String = "New [%3d]"	## Ingredient Button Text.
var ordText : String = "New [%3d]"	## Order Button Text. 

var resourceData : Resource		## Save Data Path. Setting up as a ResourceData causes a parse error. 

@onready var ing_button = $ingBox/ingButton
@onready var ord_button = $ordBox/ordButton
@onready var ing_text = $ingBox/ingText
@onready var ord_text = $ordBox/ordText

func _ready():
	resourceData = ResourceLoader.load("res://addons/resource_manager/resourceData.tres")
	update_button_labels()
	
	# Set up all of the directory dependencies.
	var error = DirAccess.make_dir_recursive_absolute(ingOutPath) 
	error = DirAccess.make_dir_recursive_absolute(ordOutPath) 

## Updates the button labels with the current ID (next). 
func update_button_labels() -> void: 
	ing_button.text = ingText % resourceData.ingID
	ord_button.text = ordText % resourceData.orderID

## When the new Ingredient button is pressed, create a new Ingredient. 
func _on_ing_button_pressed():
	var newIngredient = ingPath.new()
	
	# Create the new ingredient name file/path. 
	var ingNamePath : String = ingOutPath + (ing_text.text + "_" + str(resourceData.ingID)) + ".tres"
	
	# Set up the new ingredient data. 
	newIngredient.Name = ing_text.text
	newIngredient.Amount = 0
	newIngredient.ID = resourceData.ingID
	
	# Save the new ingredient resource. 
	resourceData.ingID += 1
	ResourceSaver.save(newIngredient, ingNamePath)
	
	# Update the button labels and clear the ingredient lineedit. 
	update_button_labels()
	ing_text.text = ""
	
	# Open the resource in the inspector window. 
	EditorInterface.get_inspector().resource_selected.emit(newIngredient, ingNamePath)
	_save_resource_data()

## When the new Order button is pressed, create a new Order. 
func _on_ord_button_pressed():
	var newOrder = ordPath.new()
	
	# Create the new order name file/path. 
	var ordNamePath : String = ordOutPath + (ord_text.text + "_" + str(resourceData.orderID)) + ".tres"
	
	# Set up the new order data. 
	newOrder.Name = ord_text.text
	newOrder.ID = resourceData.orderID
	
	# Save the new order resource. 
	resourceData.orderID += 1
	ResourceSaver.save(newOrder, ordNamePath)
	
	# Update the button labels and clear the order lineedit. 
	update_button_labels()
	ord_text.text = ""
	
	# Open the resource in the inspector window. 
	EditorInterface.get_inspector().resource_selected.emit(newOrder, ordNamePath)
	_save_resource_data()

## Call to save the resource data. 
func _save_resource_data() -> void:
	ResourceSaver.save(resourceData, "res://addons/resource_manager/resourceData.tres")
	
func _exit_tree():
	_save_resource_data()
