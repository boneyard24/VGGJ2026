extends Node2D

@onready var progress_train: Sprite2D = $ProgressTrain
@onready var rail_road: Sprite2D = $RailRoad
var dialogue_duration: float = 0.0
var velocity: float = 0.0
var game_over := false
var rail_length: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogue_box = get_tree().root.get_node("Main/DialogueBox")
	print("Rail length calculated: ", rail_length)
	if dialogue_box:
		calculate_velocity()
	else:
		push_warning("Could not find dialogue box node")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !game_over:
		if velocity > 0:
			progress_train.position.x += velocity * delta
			# Stop when train reaches the end of railroad
			if progress_train.position.x >= rail_length:
				velocity = 0

func UpdateProgress(_progressChange: float):
	pass

func stop() -> void:
	game_over = true

func start() -> void:
	game_over = false
	progress_train.position.x = 0

func _on_dialogue_box_dialogue_duration_calculated(duration: float) -> void:
	dialogue_duration = duration

func calculate_velocity() -> void:
	if dialogue_duration > 0:
		rail_length = rail_road.texture.get_width() - progress_train.texture.get_width() - 92
		velocity = rail_length / dialogue_duration
		print("Calculated train velocity: ", velocity)
	else:
		push_warning("Dialogue duration is zero, cannot calculate velocity.")
