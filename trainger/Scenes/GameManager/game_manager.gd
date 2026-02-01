extends Node2D

@onready var qteSpawnTimer := $QTESpawnTimer

#const QTEScene: PackedScene = preload("res://Scenes/QTE/QTEPopup.tscn")
@onready var QTEScene = preload("res://Scenes/QTE/QTEPopup.tscn")
@onready var GameOverUI := $"../GameOver"
@onready var PlayerBox := $"../PlayerBox"


const MAX_FAILS := 3
var current_fails := 0
var spawn_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameOverUI.visible = false
	qteSpawnTimer.timeout.connect(SpawnQTE)
	qteSpawnTimer.start(2) # Manually start the timer if Auto Start is off

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if (event.is_action_released("enter", true)) :
		ResetGame()

func SpawnQTE() -> void:
	print("SPAWNQTE")
	spawn_count += 1
	var instance : qte_popup = QTEScene.instantiate()
	
	var rng := RandomNumberGenerator.new()
	instance.ComboLength = rng.randi_range(1, (1+spawn_count) / 2)
	
	add_child(instance)
	instance.qte_popup_complete.connect(_qte_result)
	

func _qte_result(eventSuccess: bool) -> void:
	print("GM: Event Success - ", eventSuccess)
	qteSpawnTimer.start(2)
	
	PlayerBox.event_result(eventSuccess)
	
	if (!eventSuccess):
		current_fails += 1
		if (current_fails >= MAX_FAILS):
			GameOver()
	
func GameOver() -> void:
	print("GM: GAMEOVER GAMEOVER GAMEOVER GAMEOVER GAMEOVER")
	qteSpawnTimer.stop()
	GameOverUI.visible = true
	
func ResetGame() -> void:
	current_fails = 0
	GameOverUI.visible = false
	qteSpawnTimer.start(2) # Manually start the timer if Auto Start is off
