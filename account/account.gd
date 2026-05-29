extends Node

var websocket_url = "wss://realtime.artifactsmmo.com"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()

var init_message =  {"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Imt5bGxpYW4ucGVycmluQGdtYWlsLmNvbSIsInBhc3N3b3JkX2NoYW5nZWQiOm51bGx9.n0GELlDBCZQVR8IbLcVYrzlFLe5pczmrdGmwptMkSnY", "subscriptions": ["event_spawn", "event_removed", "achievement_unlocked", "test", "account_log"]}

func _ready():
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err == OK:
		print("Connecting to %s..." % websocket_url)
		# Wait for the socket to connect.
		await get_tree().create_timer(2).timeout

		# Send data.
		print("> Sending init packet.")
		socket.send_text(str(init_message))
		set_process(true)
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
				print("< Got text data from server: %s" % packet_text)
			else:
				print("< Got binary data from server: %d bytes" % packet.size())

	# `WebSocketPeer.STATE_CLOSING` means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# `WebSocketPeer.STATE_CLOSED` means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		print("Connexion fermée. Code:", socket.get_close_code(), " Reason:", socket.get_close_reason())
		set_process(false)
