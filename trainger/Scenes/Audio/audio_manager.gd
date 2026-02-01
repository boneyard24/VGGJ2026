extends Node

# number of fails to trigger the next stage in the music system
const fails_stage1 = 0
const fails_stage2 = 1


@onready var main_music: AudioStreamPlayer = $Music/MX_MainMusic_Office

@onready var ui_prompt_popup: AudioStreamPlayer = $SFX/UI/UI_Prompt_PopUp
@onready var ui_prompt_success: AudioStreamPlayer = $SFX/UI/UI_Prompt_Success
@onready var ui_prompt_failed: AudioStreamPlayer = $SFX/UI/UI_Prompt_Failed
@onready var ui_prompt_win: AudioStreamPlayer = $SFX/UI/UI_YouWin
@onready var ui_prompt_lose: AudioStreamPlayer = $SFX/UI/UI_YouLose
@onready var ui_prompt_text: AudioStreamPlayer = $SFX/UI/UI_Prompt_Text

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

func play_prompt_text() -> void:
	ui_prompt_text.play()
	
func play_restart() -> void:
	ui_prompt_lose.stop()
	ui_prompt_win.stop()
	
# MUSIC MIX SNAPSHOTS

func music_stage_begin():
	var stream : AudioStreamSynchronized = main_music.stream
	stream.set_sync_stream_volume(0, -60)
	stream.set_sync_stream_volume(1, -16)
	stream.set_sync_stream_volume(2, -60)
	stream.set_sync_stream_volume(3, -60)
	stream.set_sync_stream_volume(4, -60)
	stream.set_sync_stream_volume(5, -60)

func music_stage_1():
	var stream : AudioStreamSynchronized = main_music.stream
	stream.set_sync_stream_volume(0, -60)
	stream.set_sync_stream_volume(1, -60)
	stream.set_sync_stream_volume(2, -12)
	stream.set_sync_stream_volume(3, -14)
	stream.set_sync_stream_volume(4, -60)
	stream.set_sync_stream_volume(5, -60)

func music_stage_2():
	var stream : AudioStreamSynchronized = main_music.stream
	stream.set_sync_stream_volume(0, -60)
	stream.set_sync_stream_volume(1, -60)
	stream.set_sync_stream_volume(2, -12)
	stream.set_sync_stream_volume(3, -14)
	stream.set_sync_stream_volume(4, -12)
	stream.set_sync_stream_volume(5, -60)

func music_stage_gameover():
	var stream : AudioStreamSynchronized = main_music.stream
	stream.set_sync_stream_volume(0, -60)
	stream.set_sync_stream_volume(1, -60)
	stream.set_sync_stream_volume(2, -60)
	stream.set_sync_stream_volume(3, -60)
	stream.set_sync_stream_volume(4, -60)
	stream.set_sync_stream_volume(5, -16)

func music_stage_fe():
	var stream : AudioStreamSynchronized = main_music.stream
	stream.set_sync_stream_volume(0, -12)
	stream.set_sync_stream_volume(1, -60)
	stream.set_sync_stream_volume(2, -60)
	stream.set_sync_stream_volume(3, -60)
	stream.set_sync_stream_volume(4, -60)
	stream.set_sync_stream_volume(5, -60)

# MUSIC MIX EVENTS

func update_main_music_qte(current_fails: int) -> void:
	match current_fails:
		fails_stage1:
			music_stage_1()
		fails_stage2:
			music_stage_2()

func update_main_music_gameover() -> void:
	music_stage_gameover()

func update_main_music_reset() -> void:
	music_stage_begin()

func update_main_music_fe() -> void:
	music_stage_fe()


# Very experimental will fail
func fade_track(sync: AudioStreamSynchronized, track: int, target: float, duration: float):
	main_music.set_sync_stream
	var tween = create_tween()
	var start = sync.get_stream_volume(track)

	tween.tween_method(
		func(v): sync.set_stream_volume(track, v), start, target, duration
	)
