extends Node

const CharacterScene = preload("res://account/character/character.tscn")
const token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Imt5bGxpYW4ucGVycmluQGdtYWlsLmNvbSIsInBhc3N3b3JkX2NoYW5nZWQiOm51bGx9.n0GELlDBCZQVR8IbLcVYrzlFLe5pczmrdGmwptMkSnY"
const account_character_url = "https://api.artifactsmmo.com/accounts/Tellenn/characters"
const websocket_url = "wss://realtime.artifactsmmo.com"
var characters : Dictionary = {}

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()

var init_message =  {"token": token, "subscriptions": ["event_spawn", "event_removed", "achievement_unlocked", "test", "account_log"]}

func _ready():
	set_process(false)
	var account_request_status = $HTTPRequest.request(account_character_url)
	if account_request_status != OK:
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
	print("Account character data fetched")
	
	for character_data in content["data"]:
		var character = CharacterScene.instantiate()
		add_child(character)
		character.update(character_data)
		characters[character_data["name"]] = character
		
	var ws_status = socket.connect_to_url(websocket_url)
	if ws_status == OK:
		set_process(true)
		print("Connecting to %s..." % websocket_url)
		await get_tree().create_timer(5).timeout

		print("> Sending init packet.")
		socket.send_text(str(init_message))
	else:
		push_error("Unable to connect.")
		set_process(false)


func _process(_delta):
	# Call this in `_process()` or `_physics_process()`.
	# Data transfer and state updates will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# `WebSocketPeer.STATE_OPEN` means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				var text = JSON.parse_string(packet_text)
				if text["type"] == "account_log":
					var character_activity = text["data"]
					print(character_activity["description"])
					if character_activity["type"] == "movement":
						var characterNode = characters[character_activity["character"]]
						var path : Array[Vector2] = []
						for pathstep in character_activity["content"]["path"]:
							path.append(Vector2(pathstep[0],pathstep[1]))
						characterNode.move_using_path(path)
				elif text["type"] == "event_spawn":
					print("Received a message about "+text["type"])
				elif text["type"] == "event_removed":
					print("Received a message about "+text["type"])
				elif text["type"] == "achievement_unlocked":
					print("Received a message about "+text["type"])
				elif text["type"] == "test":
					print("Received test message")
				else :
					print("Unsupported message type received : "+text["type"])
			else:
				print("< Got binary data from server: %d bytes" % packet.size())

	# `WebSocketPeer.STATE_CLOSING` means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# `WebSocketPeer.STATE_CLOSED` means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		print("Connection closed. Code:", socket.get_close_code(), " Reason:", socket.get_close_reason())
		set_process(false)
