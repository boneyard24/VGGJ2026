extends Node2D

@onready var QtePopup : qte_popup = $QtePopup # Reference the Timer node
@export var QTEPOP : qte_popup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QTEPOP.qte_popup_done.connect(_on_qteTimer_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
 
func _on_qteTimer_completed(eventSuccess : bool):
	print("Timercompleted: ", eventSuccess)
	
