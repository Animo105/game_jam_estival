extends Node
@warning_ignore_start("unused_signal")

signal item_picked_up
signal enemy_death
signal player_death
signal player_life_changing(new_value : int, decreasing : bool)
signal start_player_health_gain(REGEN_RATE :int, life_gain_timer :Timer)
