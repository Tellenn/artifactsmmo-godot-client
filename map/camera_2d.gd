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
	move_to(direction)

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
