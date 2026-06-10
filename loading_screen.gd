extends Control

const OVERWORLD_PATH := "res://map/worldmap.tscn"
var _progress := []
var _world_map_instance: Node = null
var progress_bar

func _ready():
	print("Initializing loading")
	visible = true
	progress_bar = ProgressBar.new()
	self.add_child(progress_bar)
	progress_bar.value = 0
	progress_bar.show_percentage = true
	progress_bar.indeterminate = false
	progress_bar.custom_minimum_size = Vector2(300, 30)
	progress_bar.set_anchors_and_offsets_preset(
		Control.PRESET_TOP_LEFT,
		Control.PRESET_MODE_KEEP_SIZE
	)
	ResourceLoader.load_threaded_request(OVERWORLD_PATH)

func _process(_delta):
	var status := ResourceLoader.load_threaded_get_status(OVERWORLD_PATH, _progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		progress_bar.value = _progress[0] * 30.0
		return
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed: PackedScene = ResourceLoader.load_threaded_get(OVERWORLD_PATH)
		_world_map_instance = packed.instantiate()
		if _world_map_instance.has_signal("loading_progress_changed"):
			_world_map_instance.loading_progress_changed.connect(_on_world_progress_changed)
		if _world_map_instance.has_signal("loading_finished"):
			_world_map_instance.loading_finished.connect(_on_world_loading_finished)
		
		# In order to avoid the camera being moveable.
		var camera = _world_map_instance.get_node("Camera2D")
		camera.process_mode = Node.PROCESS_MODE_DISABLED
		
		# To do right now to all the _process to work
		get_tree().root.add_child(_world_map_instance)
		_world_map_instance.visible = false
		set_process(false)

func _on_world_progress_changed(value: float) -> void:
	progress_bar.value = 30.0 + value * 70.0

func _on_world_loading_finished() -> void:
	var camera = _world_map_instance.get_node("Camera2D")
	camera.process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().current_scene = _world_map_instance
	_world_map_instance.visible = true
	queue_free()
