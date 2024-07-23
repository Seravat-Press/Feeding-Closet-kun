class_name OrderManager extends Node

var orderQueue : Array
var newOrderPreloaded = preload("res://UI/Orders/OrderUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_order(orderData):
	var newOrder : OrderUi = newOrderPreloaded.instantiate()
	newOrder.orderData = orderData
	order_enqueue(newOrder)

func order_enqueue(newOrder):
	orderQueue.append(newOrder)
	
func order_dequeue():
	orderQueue.pop_front()
