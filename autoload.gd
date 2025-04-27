extends Node

signal reverse_item_picked_up(mode: int)
signal ask_reverse(x: bool, y: bool)
signal next_level
signal reset_level
signal clear_items
signal player_death
signal ask_reset
signal update_level_transition(start: bool)
signal level_flipped
signal start_game
signal game_end
signal go_back_menu

var rng = RandomNumberGenerator.new()

var current_level = null
