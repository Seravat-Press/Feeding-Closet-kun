class_name Closet extends Node

@export var hungerStage : int = 0
@export var hungerTimerDuration = 30

@onready var hunger_timer = $HungerTimer
@onready var closet_image = $ClosetImage
@onready var hunger_state_label = $HungerStateLabel

signal hunger_changed(new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	hunger_timer.wait_time = hungerTimerDuration
	hunger_timer.one_shot = 0
	hunger_timer.autostart = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hunger_timer_timeout():
	if (hungerStage < 3):
		increase_hunger_stage()

func reset_hunger_timer():
	hunger_timer.stop()
	hunger_timer.start(hungerTimerDuration)
	
func increase_hunger_stage():
	hungerStage += 1
	update_closet_image()
	hunger_changed.emit(hungerStage)
	
func decrease_hunger_stage():
	if hungerStage > 0:
		hungerStage -= 1
		update_closet_image()
		hunger_changed.emit(hungerStage)

func update_closet_image():
	closet_image.texture = load("" + "Stage" + str(hungerStage))

func _on_hunger_changed():
	hunger_state_label.text = str(hungerStage)
