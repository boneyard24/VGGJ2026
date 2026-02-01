class_name qte_popup extends Node2D

#todo: stop the progress bar on success
signal qte_popup_complete(eventSuccess : bool)

@onready var QTETimer : Timer = $QTETimer
@onready var TimerBar : ProgressBar = $ProgressBar
@onready var ComboTracker : Node = $ComboTracker
@onready var SpriteBoxContainer = $SpriteBoxContainer

var MinTime := 1.0
var MaxTime := 4.0
var ComboLength := 1

var _timer_bar_progress := 0.0

#@onready var timer: Timer = $Timer # Reference the Timer node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ComboInputs = Globals.GenerateQTECombo(ComboLength)
	
	var timeMod : float = ComboLength / 3
	var rng := RandomNumberGenerator.new()
	var randTime := rng.randf_range(MinTime, MaxTime)
	
	randTime += timeMod
	
	TimerBar.min_value = 0
	TimerBar.max_value = randTime
	
	
	QTETimer.timeout.connect(_on_timer_timeout)
	QTETimer.start(randTime) # Manually start the timer if Auto Start is off
	
	ComboTracker.combo_result.connect(end_qte)
	ComboTracker.Setup(ComboInputs)
	
	SpriteBoxContainer.MakeNewSprites(ComboInputs)
	
	var xBuffer : float = ComboLength * 70
	var yBuffer : float = 150.0
	
	"""
	#Random Screen Position Segment
	"""
	# Get the screen size (viewport dimensions) as a Vector2
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	#screen_size = get_viewport_rect().size
	#screen_size = Cam2d.get_viewport().size
	
	
	# Generate random X and Y coordinates within the screen boundaries
	# Use randf_range for floating-point positions, or randi_range for integer positions
	var rand_x: float = rng.randf_range(0, screen_size.x)
	rand_x = clamp(rand_x, xBuffer, screen_size.x-xBuffer)
	var rand_y: float = rng.randf_range(0, screen_size.y)
	rand_y = clamp(rand_y, yBuffer, screen_size.y-yBuffer)
	
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
	
func update_progress_bar(delta: float):
	_timer_bar_progress += delta
	TimerBar.value = _timer_bar_progress
	
	
func end_qte(successful: bool):
	QTETimer.stop()
	qte_popup_complete.emit(successful)
	queue_free()
