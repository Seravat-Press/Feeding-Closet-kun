class_name OrderManager extends Control

var orderQueue : Array
var newOrderPreloaded = preload("res://UI/Orders/OrderUI.tscn")

@onready var visual_queue = $VisualQueue
@onready var visual = $Visual

var focusedOrder : OrderUi

# Called when the node enters the scene tree for the first time.
func _ready():
	visual.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_order(orderData):
	var newOrder : OrderUi = newOrderPreloaded.instantiate()
	newOrder.orderData = orderData
	order_enqueue(newOrder)

func order_enqueue(newOrder):
	newOrder.connect("entered_order", Callable(self,"_on_order_focused"))
	newOrder.connect("left_order", Callable(self,"_on_order_unfocused"))
	visual_queue.add_child(newOrder)
	orderQueue.append(newOrder)

func order_dequeue():
	visual_queue.remove_child(orderQueue.pop_front())


## IngredientUI emits signal for "picked_up" and passes itself. 
func _on_order_focused(inOrder : OrderUi) -> void:
	focusedOrder = inOrder

## IngredientUI emits signal for "released" and passes itself.
func _on_order_unfocused(outOrder : OrderUi) -> void:
	if focusedOrder == outOrder:
		focusedOrder = null

func get_focused_order() -> Order:
	if focusedOrder != null:
		return focusedOrder.orderData
	else:
		return null
# TODO: Manage an order completion/failure
