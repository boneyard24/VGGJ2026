extends Node2D

@onready var progress_train: Sprite2D = $ProgressTrain
var dialogue_duration: float = 0.0
var velocity: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogue_box = get_tree().root.get_node("Main/DialogueBox")
	if dialogue_box:
		dialogue_box.dialogue_duration_calculated.connect(_on_dialogue_box_dialogue_duration_calculated)
	else:
		push_warning("Could not find dialogue box node")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if velocity > 0:
		progress_train.position.x += velocity * delta
		# Stop when train reaches the end of the display
		if progress_train.position.x >= get_viewport().get_visible_rect().size.x - progress_train.texture.get_width():
			velocity = 0

func UpdateProgress(_progressChange: float):
	pass


func _on_dialogue_box_dialogue_duration_calculated(duration: float) -> void:
	dialogue_duration = duration
	if dialogue_duration > 0:
		velocity = get_viewport().get_visible_rect().size.x / dialogue_duration
	print("tension_progress_bar.gd received dialogue duration: ", dialogue_duration)
	print("Velocity set to: ", velocity)
