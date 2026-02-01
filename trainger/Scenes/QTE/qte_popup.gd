class_name qte_popup extends Node2D

#todo: stop the progress bar on success

@onready var QTETimer : Timer = $QTETimer
@onready var TimerBar : ProgressBar = $ProgressBar
@onready var Cam2d : ProgressBar = $"Main/Camera2D"

var MinTime := 1.0
var MaxTime := 5.0

var _timer_bar_progress := 0.0

signal qte_popup_complete(eventSuccess : bool)
#@onready var timer: Timer = $Timer # Reference the Timer node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	var randTime := rng.randf_range(MinTime, MaxTime)
	
	TimerBar.min_value = 0
	TimerBar.max_value = randTime
	
	QTETimer.timeout.connect(_on_timer_timeout)
	QTETimer.start(randTime) # Manually start the timer if Auto Start is off
	
	"""
	#Random Screen Position Segment
	"""
	# Get the screen size (viewport dimensions) as a Vector2
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	screen_size = get_viewport_rect().size
	screen_size = Cam2d.get_viewport().size
	
	
	# Generate random X and Y coordinates within the screen boundaries
	# Use randf_range for floating-point positions, or randi_range for integer positions
	var rand_x: float = rng.randf_range(0, screen_size.x)
	var rand_y: float = rng.randf_range(0, screen_size.y)
	
	# Create a new random position vector
	var random_position: Vector2 = Vector2(rand_x, rand_y)
	
	# Set the object's position
	position = random_position
	
	print("New random position: ", random_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_progress_bar(delta)
	
func _on_timer_timeout():
	# Code to execute when the timer finishes
	print("QTE_POPUP TIMER COMPLETED! FAIL")
	end_qte(false)
	# You can restart the timer here if not One Shot:
	# timer.start() 
	
func _input(event: InputEvent) -> void:
	if (event.is_action_released("ui_left", true)) :
		QTETimer.stop() #stop the timer
		print("QTE_POPUP TIMER COMPLETED! SUCCESS")
		end_qte(true)
	
func update_progress_bar(delta: float):
	_timer_bar_progress += delta
	TimerBar.value = _timer_bar_progress
	
func end_qte(successful: bool):
	qte_popup_complete.emit(successful)
	queue_free()
