extends TileMapLayer

var max_parrallel = 50
var total_maps
var pending_maps: Array = []
var active_requests := 0
var map_resource_uri = "https://www.artifactsmmo.com/images/maps/"
var map_layout_info_api = "https://api.artifactsmmo.com/maps?layer=overworld&size=1000"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	load_map_info()

func load_map_info():
	var err = $HTTPRequest.request(map_layout_info_api)
	if err != OK:
		push_error("Cannot send a request to artifacts server")
		return
	var data = await $HTTPRequest.request_completed
	
	var result: int = data[0]
	var response_code: int = data[1]
	var body = data[3].get_string_from_utf8()
	var content = JSON.parse_string(body)
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		push_error("Failed loading")
		return
	print("Raw overworld map has been fetched")
	pending_maps = content["data"]
	total_maps = pending_maps.size()
	add_to_queue()

func add_to_queue():
	get_parent().loading_progress_changed.emit(1.0-(0.0+pending_maps.size())/total_maps)
	if active_requests == 0 and pending_maps.size() == 0:
		get_parent().loading_finished.emit()
		return
	while active_requests < max_parrallel and pending_maps.size() > 0:
		var map = pending_maps.pop_front()
		var http := HTTPRequest.new()
		add_child(http)
		active_requests += 1
		http.request_completed.connect(_instanciate_map.bind(http, map["x"], map["y"]))
		http.request(map_resource_uri+map["skin"]+".png")

func _instanciate_map(_result, response_code, _headers, body, http, x, y):
	http.queue_free()
	active_requests -= 1
	if response_code != 200:
		add_to_queue()
		return
	var tileset := self.tile_set
	if tileset == null:
		tileset = TileSet.new()
		self.tile_set = tileset

	var source := TileSetAtlasSource.new()
	var map_image = Image.new()
	map_image.load_png_from_buffer(body)
	
	var texture := ImageTexture.create_from_image(map_image)
	
	source.texture = texture
	source.texture_region_size = map_image.get_size()
	source.create_tile(Vector2i(0, 0))
	var source_id := tileset.add_source(source)
	self.set_cell(Vector2i(x,y),source_id, Vector2i(0,0))
	add_to_queue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
