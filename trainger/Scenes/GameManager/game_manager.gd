extends Node2D

@onready var qteSpawnTimer := $QTESpawnTimer

#const QTEScene: PackedScene = preload("res://Scenes/QTE/QTEPopup.tscn")
@onready var QTEScene = preload("res://Scenes/QTE/QTEPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	qteSpawnTimer.timeout.connect(SpawnQTE)
	qteSpawnTimer.start(2) # Manually start the timer if Auto Start is off

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SpawnQTE() -> void:
	print("SPAWNQTE")
	var instance : qte_popup = QTEScene.instantiate()
	#QTEScene.instantiate()
	#QTEScene.MinTime = 1
	#QTEScene.MaxTime = 3
	add_child(instance)
	instance.qte_popup_complete.connect(_qte_result)
	#.connect(_on_timer_timeout)
	#var new_qte = qte_popup.

func _qte_result(eventSuccess: bool) -> void:
	print("GM: Event Success - ", eventSuccess)
	qteSpawnTimer.start(2)
	
