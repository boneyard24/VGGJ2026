extends Node

signal combo_result(eventSuccess : bool)

var input_buffer = []
var combo_window = 0.5 # Seconds allowed between inputs
var input_tracking := false
#@onready var timer = $Timer

# Predefined combos
var SPECIAL_MOVE : Array[String]
const INPUT_OPTIONS = ["up", "down", "left", "right"]

func _ready():
	pass
	#timer.wait_time = combo_window
	#timer.one_shot = true
	
func Setup(combo: Array[String]):
	#SPECIAL_MOVE = Globals.GenerateQTECombo(combo_length)
	SPECIAL_MOVE = combo
	input_tracking = true
	

func _unhandled_input(event):
	if (input_tracking):
		if event.is_action_pressed("up"):
			add_to_combo("up")
		elif event.is_action_pressed("down"):
			add_to_combo("down")
		elif event.is_action_pressed("left"):
			add_to_combo("left")
		elif event.is_action_pressed("right"):
			add_to_combo("right")

func add_to_combo(action_name):
	input_buffer.append(action_name)
	#timer.start() # Reset window on new input
	check_combo()
	
func check_combo():
	print("INPUTBUFFER: ", input_buffer.size())
	print("SPECIAL_MOVE: ", SPECIAL_MOVE.size())
	if input_buffer.size() > SPECIAL_MOVE.size():
		combo_end(false, "TOO MANY INPUTS!")
	
	var index := 0
	for input in input_buffer:
		if (input != SPECIAL_MOVE[index]):
			combo_end(false, "WRONG INPUTS!")
			break
		index += 1
	
	if input_buffer == SPECIAL_MOVE:
		combo_end(true, "CORRECT!")
		#timer.stop()

func combo_end(success:bool, msg:String):
	input_tracking = false
	input_buffer.clear()
	print("COMBO RESULT: ", success, " : ", msg)
	combo_result.emit(success)
	
	
#func _on_timer_timeout():
#	input_buffer.clear() # Reset combo if too slow
