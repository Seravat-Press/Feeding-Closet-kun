class_name OrderManager extends Control

var orderQueue : Array
var newOrderPreloaded = preload("res://UI/Orders/OrderUI.tscn")

@onready var visual_queue = $VisualQueue
@onready var visual = $Visual

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
	visual_queue.add_child(newOrder)
	orderQueue.append(newOrder)

func order_dequeue():
	visual_queue.remove_child(orderQueue.pop_front())

## When a dude is spawned, attach its order to the queue
func _on_dude_manager_dude_spawned(dude):
	generate_order(dude.order)
