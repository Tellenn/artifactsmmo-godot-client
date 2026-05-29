extends CharacterBody2D

var grid_size = 224
var seconds_to_move_a_tile = 1

@export var websocket_url = "wss://realtime.artifactsmmo.com"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
	var end = position + direction * grid_size
	tween.tween_property(self, "position", end, seconds_to_move_a_tile*tile_quantity)
	await tween.finished
	position = end

	set_process(true)

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
