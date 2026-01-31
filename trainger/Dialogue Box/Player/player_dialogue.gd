extends Panel

@onready var text_label: RichTextLabel = $DialogueText

enum { SUCCESS, FAILURE }
var success_dialogue: Array[String] = []



var success_current_line := 0
var success_typing_speed := 0.0
var success_line_wait_time := 0.0

var failure_current_line := 0
var failure_typing_speed := 0.0
var failure_line_wait_time := 0.0

func _ready():
	success_dialogue = load_dialogue_json("res://Dialogue Box/dialogue_data.json")
	if success_dialogue.is_empty():
		return

	start_dialogue()

func load_dialogue_json(path: String) -> Array[String]:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open dialogue file: " + path)
		return []

	var json_text := file.get_as_text()
	var parsed = JSON.parse_string(json_text)
	var lines : Array[String] = []

	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid JSON format in: " + path)
		return []
	
	success_typing_speed = parsed["dialogue"]["player"]["success"]["typing_speed"]
	success_line_wait_time = parsed["dialogue"]["player"]["success"]["line_wait_time"]

	# Navigate to: dialogue → boss → lines
	if parsed.has("dialogue") \
	and parsed["dialogue"].has("boss") \
	and parsed["dialogue"]["boss"].has("lines"):

		var raw_lines = parsed["dialogue"]["boss"]["lines"]
		for item in raw_lines:
			lines.append(str(item))
		return lines

	push_error("Dialogue JSON missing boss lines: " + path)
	return []

func start_dialogue():
	success_current_line = 0
	await show_line(success_dialogue[success_current_line])

func show_line(text: String) -> void:
	text_label.clear()

	for ch in text:
		text_label.append_text(ch)
		await get_tree().create_timer(success_typing_speed).timeout

	await get_tree().create_timer(success_line_wait_time).timeout
	await advance_line()

func advance_line() -> void:
	success_current_line += 1

	if success_current_line < success_dialogue.size():
		await show_line(success_dialogue[success_current_line])
	else:
		dialogue_finished()

func dialogue_finished():
	print("Dialogue complete.")
