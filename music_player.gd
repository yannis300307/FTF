extends AudioStreamPlayer

var playlist: Array[AudioStream] = []

func _ready() -> void:
	for file in ResourceLoader.list_directory("res://assets/musics"):
		playlist.append(load("res://assets/musics/" + file))
	
	print(playlist)
	
	var last = null
	
	while true:
		playlist.shuffle()
		if playlist[0] == last:
			playlist.pop_at(0)
			playlist.append(last)
		for music in playlist:
			stream = music
			play()
			await finished
			last = music
