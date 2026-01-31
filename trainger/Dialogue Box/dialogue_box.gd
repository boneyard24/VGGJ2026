extends Panel

@onready var text_label: RichTextLabel = $DialogueText

var boss_dialogue: Array[String] = []
var current_line := 0

var typing_speed := 0.0
var line_wait_time := 0.0

func _ready():
	boss_dialogue = load_dialogue_json("res://Dialogue Box/dialogue_data.json")
	if boss_dialogue.is_empty():
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
	
	typing_speed = parsed["dialogue"]["boss"]["typing_speed"]
	line_wait_time = parsed["dialogue"]["boss"]["line_wait_time"]

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
	current_line = 0
	await show_line(boss_dialogue[current_line])

func show_line(text: String) -> void:
	text_label.clear()

	for char in text:
		text_label.append_text(char)
		await get_tree().create_timer(typing_speed).timeout

	await get_tree().create_timer(line_wait_time).timeout
	await advance_line()

func advance_line() -> void:
	current_line += 1

	if current_line < boss_dialogue.size():
		await show_line(boss_dialogue[current_line])
	else:
		dialogue_finished()

func dialogue_finished():
	print("Dialogue complete.")
