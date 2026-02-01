extends Panel

signal dialogue_duration_calculated(duration: float)

@onready var text_label: RichTextLabel = $DialogueText

var boss_dialogue: Dictionary = {}
var current_line := 0
var current_full_text: String = ""

var typing_speed := 0.0
var line_wait_time := 0.0

var total_duration := 0.0
var stop_playback := false

func _ready():
	text_label.bbcode_enabled = true
	boss_dialogue = load_dialogue_json("res://Dialogue Box/dialogue_data.json")
	print("Loaded Boss Dialogue")

	typing_speed = boss_dialogue.typing_speed
	line_wait_time = boss_dialogue.line_wait_time

	total_duration = calculate_boss_dialogue_duration()

	if boss_dialogue.is_empty():
		push_warning("Boss dialogue is empty.")
		return
	
	start()

func load_dialogue_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Failed to open dialogue file: " + path)
		return {}

	var json_text := file.get_as_text()
	var json = JSON.parse_string(json_text)

	return json.dialogue.boss

func start():
	stop_playback = false
	current_line = 0
	await show_line(boss_dialogue.lines[current_line])

func show_line(text: String) -> void:
		current_full_text = ""
		var _visible_chars := 0
		var i := 0
		
		while i < text.length():
			if !stop_playback:
				# Check if we're at the start of a bbcode tag
				if text[i] == '[':
					var end_bracket := text.find(']', i)
					if end_bracket != -1:
						# Add the complete tag to current_full_text
						current_full_text += text.substr(i, end_bracket - i + 1)
						i = end_bracket + 1
						text_label.text = current_full_text
						continue
				
				# Regular character - add it and increment visible char count
				current_full_text += text[i]
				_visible_chars += 1
				text_label.text = current_full_text
				await get_tree().create_timer(typing_speed).timeout
				i += 1
			else:
				i = text.length()
				text_label.text = text
				dialogue_finished()

		await get_tree().create_timer(line_wait_time).timeout
		await advance_line()

func advance_line() -> void:
	if !stop_playback:
		current_line += 1

		if current_line < boss_dialogue.lines.size():
			await show_line(boss_dialogue.lines[current_line])
		else:
			dialogue_finished()

func dialogue_finished():
	if !stop_playback:
		print("Dialogue complete.")
	else:
		print("Dialogue stopped.")

func stop():
	stop_playback = true

func calculate_boss_dialogue_duration() -> float:
	var duration := 0.0
	for line in boss_dialogue.lines:
		duration += typing_speed * line.length() + line_wait_time
	
	print("dialogue_box.gd - Total Boss Dialogue Duration: ", duration)
	dialogue_duration_calculated.emit(duration)
	
	return duration
