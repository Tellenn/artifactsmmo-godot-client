extends VBoxContainer

@export var character_name: String = "Hero"
@export var character_texture: Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	
	alignment = BoxContainer.ALIGNMENT_CENTER
	custom_minimum_size = Vector2(120, 160)


	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(75, 75)
	texture_rect.texture = character_texture


	label.text = character_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	mouse_filter = Control.MOUSE_FILTER_STOP
