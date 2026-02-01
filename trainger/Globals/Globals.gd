extends Node

const INPUT_OPTIONS = ["up", "down", "left", "right"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func CheckGlobals() -> bool:
	return true

func GenerateQTECombo(length: int) -> Array[String]:
	var rng := RandomNumberGenerator.new()
	var combo : Array[String]
	
	for i in range(length):
		var rand = randi_range(0, INPUT_OPTIONS.size()-1)
		combo.append(INPUT_OPTIONS[rand])
		
	for str in combo:
		print(str)
	
	return combo
	
