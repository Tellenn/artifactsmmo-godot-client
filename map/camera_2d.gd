extends Camera2D

var seconds_to_move_a_tile = 0.5
const GRID_SIZE = 224

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = get_input_direction()
	if direction.is_zero_approx():
		return
	position = position + direction

# --- existing variables ---
var drag_speed: float = 1.0  # adjust if needed

# --- drag state ---
var _dragging: bool = false
var _drag_start_mouse: Vector2
var _drag_start_cam: Vector2

# For click & move
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_dragging = true
				_drag_start_mouse = get_viewport().get_mouse_position()
				_drag_start_cam = position
			else:
				_dragging = false

	if event is InputEventMouseMotion and _dragging:
		var delta = get_viewport().get_mouse_position() - _drag_start_mouse
		position = _drag_start_cam - delta * drag_speed

# For WASD movement
func move_to(direction: Vector2):
	set_process(false)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	var tile_quantity = abs(direction.x) + abs(direction.y)
	var end = position + direction * GRID_SIZE
	tween.tween_property(self, "position", end, seconds_to_move_a_tile*tile_quantity)
	await tween.finished
	position = end
	set_process(true)

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
