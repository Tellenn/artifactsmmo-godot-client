extends Control

const OVERWORLD_PATH := "res://map/overworld.tscn"
var _progress := []
var _overworld_instance: Node = null
var progress_bar

func _ready():
	visible = true
	progress_bar = ProgressBar.new()
	self.add_child(progress_bar)
	progress_bar.value = 0
	progress_bar.show_percentage = true
	progress_bar.indeterminate = false

func _process(_delta):
	var status := ResourceLoader.load_threaded_get_status(OVERWORLD_PATH, _progress)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = _progress[0] * 30.0
		return

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed: PackedScene = ResourceLoader.load_threaded_get(OVERWORLD_PATH)
		_overworld_instance = packed.instantiate()
		get_tree().current_scene.add_child(_overworld_instance)

		if _overworld_instance.has_signal("loading_progress_changed"):
			_overworld_instance.loading_progress_changed.connect(_on_world_progress_changed)
		if _overworld_instance.has_signal("loading_finished"):
			_overworld_instance.loading_finished.connect(_on_world_loading_finished)

		if _overworld_instance.has_method("start_loading"):
			_overworld_instance.start_loading()

		set_process(false)

func _on_world_progress_changed(value: float) -> void:
	progress_bar.value = 30.0 + value * 70.0

func _on_world_loading_finished() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.finished.connect(queue_free)
