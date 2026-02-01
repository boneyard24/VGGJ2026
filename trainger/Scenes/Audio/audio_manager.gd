extends Node

@onready var main_music: AudioStreamPlayer = $Music/MX_MainMusic_Office

@onready var ui_prompt_popup: AudioStreamPlayer = $SFX/UI/UI_Prompt_PopUp
@onready var ui_prompt_success: AudioStreamPlayer = $SFX/UI/UI_Prompt_Success
@onready var ui_prompt_failed: AudioStreamPlayer = $SFX/UI/UI_Prompt_Failed
@onready var ui_prompt_win: AudioStreamPlayer = $SFX/UI/UI_YouWin
@onready var ui_prompt_lose: AudioStreamPlayer = $SFX/UI/UI_YouLose

func play_prompt_popup() -> void:
	ui_prompt_popup.play()

func play_prompt_success() -> void:
	ui_prompt_success.play()

func play_prompt_failed() -> void:
	ui_prompt_failed.play()

func play_prompt_win() -> void:
	ui_prompt_win.play()

func play_prompt_lose() -> void:
	ui_prompt_lose.play()

func update_main_music_qte(_x: int) -> void:
	main_music.play()

# Very experimental will fail
func fade_track(sync: AudioStreamSynchronized, track: int, target: float, duration: float):
    main_music.set_sync_stream
    var tween = create_tween()
    var start = sync.get_stream_volume(track)

    tween.tween_method(
        func(v): sync.set_stream_volume(track, v), start, target, duration
    )