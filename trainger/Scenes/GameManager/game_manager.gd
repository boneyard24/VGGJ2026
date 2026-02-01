extends Node2D

@onready var qteSpawnTimer := $QTESpawnTimer

#const QTEScene: PackedScene = preload("res://Scenes/QTE/QTEPopup.tscn")
@onready var QTEScene = preload("res://Scenes/QTE/QTEPopup.tscn")
@onready var DialogScene = preload("res://Dialogue Box/Boss/DialogueBox.tscn")
@onready var GameOverUI := $"../GameOver"
@onready var YouWinUI := $"../YouWin"
@onready var PlayerBox := $"../PlayerBox"
#@onready var AudioManager := $"../AudioManager"
@onready var DialogueBox := $"../DialogueBox"
@onready var TensionProgressBar := $"../TensionProgressBar"

const MAX_FAILS := 3
var current_fails := 0
var spawn_count := 0

var GameActive := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameOverUI.visible = false
	YouWinUI.visible = false
	qteSpawnTimer.timeout.connect(SpawnQTE)
	qteSpawnTimer.start(2) # Manually start the timer if Auto Start is off
	DialogueBox.dialogue_complete.connect(YouWin)
	GameActive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if (event.is_action_released("enter", true) && !GameActive) :
		ResetGame()

func SpawnQTE() -> void:
	print("SPAWNQTE")
	spawn_count += 1
	var instance : qte_popup = QTEScene.instantiate()
	
	var rng := RandomNumberGenerator.new()
	var combo_count := rng.randi_range(1, (1+spawn_count) / 4)
	combo_count = clampi(combo_count, 1, 6)
	instance.ComboLength = combo_count
	
	add_child(instance)
	instance.qte_popup_complete.connect(_qte_result)
	AudioManager.play_prompt_popup()
	

func _qte_result(eventSuccess: bool) -> void:
	print("GM: Event Success - ", eventSuccess)
	qteSpawnTimer.start(2)
	
	PlayerBox.event_result(eventSuccess)

	if (eventSuccess):
		AudioManager.play_prompt_success()
	else:
		AudioManager.play_prompt_failed()
		AudioManager.update_main_music_qte(current_fails)
		current_fails += 1
		if (current_fails >= MAX_FAILS):
			GameOver()
	
func GameOver() -> void:
	print("GM: GAMEOVER GAMEOVER GAMEOVER GAMEOVER GAMEOVER")
	GameActive = false
	qteSpawnTimer.stop()
	GameOverUI.visible = true
	AudioManager.play_prompt_lose()
	AudioManager.update_main_music_gameover()
	DialogueBox.stop()
	TensionProgressBar.stop()
	
func YouWin() -> void:
	print("GM: WIN WIN WIN WIN WIN WIN WIN")
	GameActive = false
	qteSpawnTimer.stop()
	YouWinUI.visible = true
	AudioManager.play_prompt_win()
	AudioManager.update_main_music_gameover()
	DialogueBox.stop()
	TensionProgressBar.stop()
	
func ResetGame() -> void:	
	current_fails = 0
	GameOverUI.visible = false
	YouWinUI.visible = false
	spawn_count = 0
	qteSpawnTimer.start(2) # Manually start the timer if Auto Start is off
	AudioManager.update_main_music_reset()
	AudioManager.play_restart()
	DialogueBox.start()
	TensionProgressBar.start()
	GameActive = true
	
