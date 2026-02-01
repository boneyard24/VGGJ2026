extends Panel

@onready var text_label: RichTextLabel = $DialogueText

var boss_dialogue: Dictionary = {}
var current_line := 0

var typing_speed := 0.0
var line_wait_time := 0.0

var total_duration := 0.0

func _ready():
	boss_dialogue = load_dialogue_json("res://Dialogue Box/dialogue_data.json")

	typing_speed = boss_dialogue.typing_speed
	line_wait_time = boss_dialogue.line_wait_time

	total_duration = calculate_boss_dialogue_duration()
	print("Total Boss Dialogue Duration: ", total_duration)

	if boss_dialogue.is_empty():
		push_warning("Boss dialogue is empty.")
		return

	start_dialogue()

func load_dialogue_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Failed to open dialogue file: " + path)
		return {}

	var json_text := file.get_as_text()
	var json = JSON.parse_string(json_text)

	return json.dialogue.boss

func start_dialogue():
	current_line = 0
	await show_line(boss_dialogue.lines[current_line])

func show_line(text: String) -> void:
	text_label.clear()

	for ch in text:
		text_label.append_text(ch)
		await get_tree().create_timer(typing_speed).timeout

	await get_tree().create_timer(line_wait_time).timeout
	await advance_line()

func advance_line() -> void:
	current_line += 1

	if current_line < boss_dialogue.lines.size():
		await show_line(boss_dialogue.lines[current_line])
	else:
		dialogue_finished()

func dialogue_finished():
	print("Dialogue complete.")

func calculate_boss_dialogue_duration() -> float:
	var duration := 0.0
	for line in boss_dialogue.lines:
		duration += typing_speed * line.length() + line_wait_time
	return duration
