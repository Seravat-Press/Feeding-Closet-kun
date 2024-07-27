class_name OrderManager extends Control

signal add_shadow(amt : int, orderui : OrderUi)
signal queued_order_failed

var orderQueue : Array
var newOrderPreloaded = preload("res://UI/Orders/OrderUI.tscn")

const BOTTLE_SOUNDS = [
	preload("res://audio/sfx/bottle_1.ogg"),
	preload("res://audio/sfx/bottle_2.ogg"),
	preload("res://audio/sfx/bottle_3.ogg")]
const FAIL_SOUND = preload("res://audio/sfx/order_fail.ogg")

@onready var visual_queue = $VisualQueue
@onready var visual = $Visual
@onready var order_audio = $OrderAudio

var focusedOrder : OrderUi

# Called when the node enters the scene tree for the first time.
func _ready():
	visual.visible = false

func generate_order(orderData):
	var newOrder : OrderUi = newOrderPreloaded.instantiate()
	newOrder.install_order_data(orderData)
	order_enqueue(newOrder)

func order_enqueue(newOrder : OrderUi):
	newOrder.connect("entered_order", Callable(self,"_on_order_focused"))
	newOrder.connect("left_order", Callable(self,"_on_order_unfocused"))
	visual_queue.add_child(newOrder)
	newOrder.orderData.connect("order_completed", Callable(self, "_on_order_success"))
	newOrder.orderData.connect("order_failed", Callable(self, "_on_order_fail"))
	newOrder.activate_order()
	orderQueue.append(newOrder)

func _on_shop_devoured() -> void:
	for order in visual_queue.get_children():
		order._on_order_failed()

func order_dequeue():
	visual_queue.remove_child(orderQueue.pop_front())

## When a dude is spawned, attach its order to the queue
func _on_dude_manager_dude_spawned(dude):
	generate_order(dude.order)

## IngredientUI emits signal for "picked_up" and passes itself. 
func _on_order_focused(inOrder : OrderUi) -> void:
	focusedOrder = inOrder

## IngredientUI emits signal for "released" and passes itself.
func _on_order_unfocused(outOrder : OrderUi) -> void:
	if focusedOrder == outOrder:
		focusedOrder = null

func get_focused_order() -> OrderFull:
	if focusedOrder != null:
		return focusedOrder.orderData
	else:
		return null

func _on_order_success(orderWin : OrderFull) -> void:
	emit_signal("add_shadow", orderWin.parentUI.get_cost(), orderWin.parentUI)
	order_audio.stream = BOTTLE_SOUNDS.pick_random()
	order_audio.play()

func _on_order_fail(_order_fail : OrderFull) -> void:
	#order_audio.stream = FAIL_SOUND
	#order_audio.play()
	## Took out fail noise because it made me sad
	emit_signal("queued_order_failed")
