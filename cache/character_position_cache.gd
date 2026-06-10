extends Node

#Key : (X,Y,L) X, Y, layer
#Value : Array<CharacterName> 
var cache : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_new_character(x,y,l, characterName):
	var key = create_key(x,y,l)
	if cache.find_key(key) != null :
		return
	cache[key] = {1: characterName}

func move_character_to(oldX, oldY, oldL, x, y, l, characterName) -> int :
	var oldKey = create_key(oldX, oldY, oldL)
	var newKey = create_key(x,y,l)
	if cache.get(oldKey) != null:
		cache[oldKey].erase(cache[oldKey].find_key(characterName))
	var k = 1
	if cache.get(newKey) == null:
		cache[newKey] = {}
	while cache[newKey].has(k):
		k+=1
	cache[newKey][k] = characterName
	return k
	#There's a bug in the removing of the old values. 

func create_key(x,y,l) -> String :
	return str(float(x))+":"+str(float(y))+":"+l
	

func get_offset_by_cell_pos(cell_pos) -> Vector2:
	const offset = 44
	var x = cell_pos * offset % 224
	var y = cell_pos / 5 * offset % 224 + (cell_pos % 2 * 5)
	return Vector2(x-122.0,y-122.0)
	
