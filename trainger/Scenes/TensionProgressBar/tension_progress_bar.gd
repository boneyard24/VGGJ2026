extends Node2D

var dialogue_duration: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogue_box = get_node("res://Dialogue Box/Boss/DialogueBox")
	if dialogue_box:
		dialogue_box.dialogue_duration_calculated.connect(_on_dialogue_duration_calculated)
	else:
		push_warning("Could not find dialogue box node")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialogue_duration_calculated(duration: float) -> void:
	dialogue_duration = duration
	print("Tension bar received dialogue duration: ", dialogue_duration)

func UpdateProgress(progressChange: float):
	pass
