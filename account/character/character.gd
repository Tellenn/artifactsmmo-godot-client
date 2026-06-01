extends CharacterBody2D

const GRID_SIZE = 224
const SECONDS_TO_MOVE_TO_A_TILE = 5
var name_label
var sprite2D

var character_name : String
var account : String
var skin : String
var level : int
var xp : int
var max_xp : int
var gold : int
var speed : int
var mining_level : int
var mining_xp : int
var mining_max_xp : int
var woodcutting_level : int
var woodcutting_xp : int
var woodcutting_max_xp : int
var fishing_level : int
var fishing_xp : int
var fishing_max_xp : int
var weaponcrafting_level : int
var weaponcrafting_xp : int
var weaponcrafting_max_xp : int
var gearcrafting_level : int
var gearcrafting_xp : int
var gearcrafting_max_xp : int
var jewelrycrafting_level : int
var jewelrycrafting_xp : int
var jewelrycrafting_max_xp : int
var cooking_level : int
var cooking_xp : int
var cooking_max_xp : int
var alchemy_level : int
var alchemy_xp : int
var alchemy_max_xp : int
var hp : int
var max_hp : int
var haste : int
var critical_strike : int
var wisdom : int
var prospecting : int
var initiative : int
var threat : int
var attack_fire : int
var attack_earth : int
var attack_water : int
var attack_air : int
var dmg : int
var dmg_fire : int
var dmg_earth : int
var dmg_water : int
var dmg_air : int
var res_fire : int
var res_earth : int
var res_water : int
var res_air : int
var effects : Array
var x : int
var y : int
var layer : String
var map_id : int
var cooldown : int
var cooldown_expiration : String
var weapon_slot : String
var rune_slot : String
var shield_slot : String
var helmet_slot : String
var body_armor_slot : String
var leg_armor_slot : String
var boots_slot : String
var ring1_slot : String
var ring2_slot : String
var amulet_slot : String
var artifact1_slot : String
var artifact2_slot : String
var artifact3_slot : String
var utility1_slot : String
var utility1_slot_quantity : int
var utility2_slot : String
var utility2_slot_quantity : int
var bag_slot : String
var task : String
var task_type : String
var task_progress : int
var task_total : int
var inventory_max_items : int
var inventory : Array


@export var websocket_url = "wss://realtime.artifactsmmo.com"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label = Label.new()
	#Not setting the name as it's not setup yet. See update()
	name_label.position = Vector2(100, 200)
	name_label.z_index = 1
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.add_theme_font_size_override("font_size", 8)
	add_child(name_label)
	
	sprite2D = Sprite2D.new()
	sprite2D.position = Vector2(112,162)
	sprite2D.scale = Vector2(0.5,0.5)
	add_child(sprite2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func update(data: Dictionary) -> void:
	character_name   = data.get("name", "Unknown")
	account  = data.get("account", "")
	skin = data.get("skin", "")
	level= data.get("level", 0)
	xp = data.get("xp", 0)
	max_xp   = data.get("max_xp", 0)
	gold = data.get("gold", 0)
	speed= data.get("speed", 0)
	mining_level = data.get("mining_level", 0)
	mining_xp= data.get("mining_xp", 0)
	mining_max_xp= data.get("mining_max_xp", 0)
	woodcutting_level= data.get("woodcutting_level", 0)
	woodcutting_xp   = data.get("woodcutting_xp", 0)
	woodcutting_max_xp   = data.get("woodcutting_max_xp", 0)
	fishing_level= data.get("fishing_level", 0)
	fishing_xp   = data.get("fishing_xp", 0)
	fishing_max_xp   = data.get("fishing_max_xp", 0)
	weaponcrafting_level= data.get("weaponcrafting_level", 0)
	weaponcrafting_xp   = data.get("weaponcrafting_xp", 0)
	weaponcrafting_max_xp   = data.get("weaponcrafting_max_xp", 0)
	gearcrafting_level  = data.get("gearcrafting_level", 0)
	gearcrafting_xp = data.get("gearcrafting_xp", 0)
	gearcrafting_max_xp = data.get("gearcrafting_max_xp", 0)
	jewelrycrafting_level   = data.get("jewelrycrafting_level", 0)
	jewelrycrafting_xp  = data.get("jewelrycrafting_xp", 0)
	jewelrycrafting_max_xp  = data.get("jewelrycrafting_max_xp", 0)
	cooking_level= data.get("cooking_level", 0)
	cooking_xp   = data.get("cooking_xp", 0)
	cooking_max_xp   = data.get("cooking_max_xp", 0)
	alchemy_level= data.get("alchemy_level", 0)
	alchemy_xp   = data.get("alchemy_xp", 0)
	alchemy_max_xp   = data.get("alchemy_max_xp", 0)
	hp   = data.get("hp", 0)
	max_hp   = data.get("max_hp", 0)
	haste= data.get("haste", 0)
	critical_strike  = data.get("critical_strike", 0)
	wisdom   = data.get("wisdom", 0)
	prospecting  = data.get("prospecting", 0)
	initiative   = data.get("initiative", 0)
	threat   = data.get("threat", 0)
	attack_fire  = data.get("attack_fire", 0)
	attack_earth = data.get("attack_earth", 0)
	attack_water = data.get("attack_water", 0)
	attack_air   = data.get("attack_air", 0)
	dmg  = data.get("dmg", 0)
	dmg_fire = data.get("dmg_fire", 0)
	dmg_earth= data.get("dmg_earth", 0)
	dmg_water= data.get("dmg_water", 0)
	dmg_air  = data.get("dmg_air", 0)
	res_fire = data.get("res_fire", 0)
	res_earth= data.get("res_earth", 0)
	res_water= data.get("res_water", 0)
	res_air  = data.get("res_air", 0)
	effects  = data.get("effects", [])
	x= data.get("x", 0)
	y= data.get("y", 0)
	layer= data.get("layer", "")
	map_id   = data.get("map_id", 0)
	cooldown = data.get("cooldown", 0)
	cooldown_expiration  = data.get("cooldown_expiration", "")
	weapon_slot  = data.get("weapon_slot", "")
	rune_slot= data.get("rune_slot", "")
	shield_slot  = data.get("shield_slot", "")
	helmet_slot  = data.get("helmet_slot", "")
	body_armor_slot  = data.get("body_armor_slot", "")
	leg_armor_slot   = data.get("leg_armor_slot", "")
	boots_slot   = data.get("boots_slot", "")
	ring1_slot   = data.get("ring1_slot", "")
	ring2_slot   = data.get("ring2_slot", "")
	amulet_slot  = data.get("amulet_slot", "")
	artifact1_slot   = data.get("artifact1_slot", "")
	artifact2_slot   = data.get("artifact2_slot", "")
	artifact3_slot   = data.get("artifact3_slot", "")
	utility1_slot  = data.get("utility1_slot", "")
	utility1_slot_quantity = data.get("utility1_slot_quantity", 0)
	utility2_slot  = data.get("utility2_slot", "")
	utility2_slot_quantity = data.get("utility2_slot_quantity", 0)
	bag_slot = data.get("bag_slot", "")
	task = data.get("task", "")
	task_type= data.get("task_type", "")
	task_progress= data.get("task_progress", 0)
	task_total   = data.get("task_total", 0)
	inventory_max_items  = data.get("inventory_max_items", 0)
	inventory= data.get("inventory", [])
	print("Personnage mis à jour : %s (niveau %d)" % [character_name, level])
	name_label.text = character_name
	_load_sprite(skin)
	update_position()

func update_position():
	position = Vector2(x,y) * GRID_SIZE

func move_to(target_cell: Vector2):
	# The target cell is in "map" x/y
	# Internal coordinates are pixel based, and are x224 (GRID_SIZE)
	
	var end = target_cell * GRID_SIZE
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", end, SECONDS_TO_MOVE_TO_A_TILE)
	await tween.finished

func move_using_path(path : Array[Vector2]):
	for cell in path:
		await move_to(cell)


func _load_sprite(sprite_name) -> void:
	var url = "https://www.artifactsmmo.com/images/characters/"+sprite_name+".png"
	
	AssetCache.get_sprite(url, func(texture: ImageTexture):
		sprite2D.texture = texture
	)
	
