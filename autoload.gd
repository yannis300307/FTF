extends Node

signal reverse_item_picked_up(mode: int)
signal ask_reverse(x: bool, y: bool)
signal next_level
signal reset_level

var current_level = null
