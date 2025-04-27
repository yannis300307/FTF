extends Control


var chrono = -1.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.start_game.connect(start_chrono)
	Autoload.game_end.connect(game_finished)


func start_chrono():
	chrono = Time.get_unix_time_from_system()

func game_finished():
	var total_time = Time.get_unix_time_from_system()-chrono
	$total_time.text = "You finished the game in " + format_time(total_time)

func format_time(time: float) -> String:
	var seconds = int(time) % 60
	var minutes = floori(int(time) / 60)%60
	var hours = floor(int(time) / 3600)
	
	var hm_connector = ", " if minutes and hours else ""
	var sm_connector = " and " if minutes and minutes else ""
	var hs_connector = " and " if hours and seconds and not minutes else ""
	
	var f_hours = ("%s hours" % hours) if hours else ""
	var f_minutes = ("%s minutes" % minutes) if minutes else ""
	var f_seconds = ("%s seconds" % seconds) if seconds else ""
	
	return f_hours + hm_connector + hs_connector + f_minutes + sm_connector + f_seconds


func _on_go_menu_pressed() -> void:
	Autoload.go_back_menu.emit()
