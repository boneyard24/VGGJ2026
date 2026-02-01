extends Panel

@onready var text_label: RichTextLabel = $DialogueText

var player_dialogue: Dictionary = {}

var success_current_line := 0
var success_typing_speed := 0.0
var success_line_wait_time := 0.0

var failure_current_line := 0
var failure_typing_speed := 0.0
var failure_line_wait_time := 0.0

func _ready():
	
	text_label.clear()

	player_dialogue = load_dialogue_json("res://Dialogue Box/dialogue_data.json")

	success_typing_speed = player_dialogue.success.typing_speed
	success_line_wait_time = player_dialogue.success.line_wait_time

	failure_typing_speed = player_dialogue.failure.typing_speed
	failure_line_wait_time = player_dialogue.failure.line_wait_time

	if player_dialogue.is_empty():
		push_warning("Player dialogue is empty.")
		return

	# TODO: Catch whatever event triggers success or failure dialogue
	await send_success_dialogue()
	await send_failure_dialogue()

func load_dialogue_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Failed to open dialogue file: " + path)
		return {}

	var json_text := file.get_as_text()
	var json = JSON.parse_string(json_text)

	return json.dialogue.player

func send_success_dialogue():
	await show_line(player_dialogue.success.lines[success_current_line], success_typing_speed, success_line_wait_time)
	success_current_line += 1

func send_failure_dialogue():
	await show_line(player_dialogue.failure.lines[failure_current_line], failure_typing_speed, failure_line_wait_time)
	failure_current_line += 1

func show_line(text: String, typing_speed: float, line_wait_time: float) -> void:

	for ch in text:
		text_label.append_text(ch)
		await get_tree().create_timer(typing_speed).timeout

	await get_tree().create_timer(line_wait_time).timeout
	text_label.clear()
