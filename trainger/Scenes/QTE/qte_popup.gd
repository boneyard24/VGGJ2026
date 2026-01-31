class_name qte_popup extends Node2D

@export var QTETimer : Timer
@export var MinTime := 1.0
@export var MaxTime := 5.0

signal qte_popup_done(eventSuccess : bool)
#@onready var timer: Timer = $Timer # Reference the Timer node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QTETimer.timeout.connect(_on_timer_timeout)
	QTETimer.start() # Manually start the timer if Auto Start is off

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_timer_timeout():
	# Code to execute when the timer finishes
	print("QTE_POPUP TIMER COMPLETED! FAIL")
	qte_popup_done.emit(false)
	# You can restart the timer here if not One Shot:
	# timer.start() 
	
func _input(event: InputEvent) -> void:
	if (event.is_action_released("ui_left", true)) :
		QTETimer.stop() #stop the timer
		print("QTE_POPUP TIMER COMPLETED! SUCCESS")
		qte_popup_done.emit(true)
	
	
