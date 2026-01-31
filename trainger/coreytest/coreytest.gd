extends Node2D

@onready var QtePopup : qte_popup = $QtePopup # Reference the Timer node
@export var QTEPOP : qte_popup
@export var progBar : ProgressBar

var progBarVal := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QTEPOP.qte_popup_complete.connect(_on_qteTimer_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("value increase: ", delta)
	progBarVal += delta
	progBar.value = progBarVal
	print("value increase: ", progBar.value)
 
func _on_qteTimer_completed(eventSuccess : bool):
	print("Timercompleted: ", eventSuccess)
	
