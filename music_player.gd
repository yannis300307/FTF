extends AudioStreamPlayer

var playlist: Array[AudioStream] = []

func _ready() -> void:
	var music_dir = DirAccess.open("res://assets/musics")
	music_dir.list_dir_begin()
	var file = "-"
	while file != "":
		file = music_dir.get_next()
		if not music_dir.current_is_dir() and file.ends_with(".mp3"):
			playlist.append(load("res://assets/musics/" + file))
	music_dir.list_dir_end()
	
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
