extends Node


var _cache: Dictionary = {}

func get_sprite(url: String, callback: Callable) -> void:
	# Already in cache → return immediately
	if _cache.has(url):
		callback.call(_cache[url])
		return

	# Not in cache → fetch it
	var http = HTTPRequest.new()
	add_child(http)
	
	http.request_completed.connect(saveImageToCache.bind(url, callback, http))
	http.request(url)

func saveImageToCache(result, code, _headers, body, url, callback, http):
	if result == HTTPRequest.RESULT_SUCCESS and code == 200:
		var image = Image.new()
		image.load_png_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		_cache[url] = texture  # store in cache
		callback.call(texture)
	else:
		push_error("SpriteCache: failed to fetch " + url)
		http.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
