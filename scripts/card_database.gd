extends Node

var all_cards: Array[CardData] = [
	preload("res://data/cards/card_01.tres"),
	preload("res://data/cards/card_02.tres"),
	preload("res://data/cards/card_03.tres"),
	preload("res://data/cards/card_04.tres"),
	preload("res://data/cards/card_05.tres"),
	preload("res://data/cards/card_06.tres"),
	preload("res://data/cards/card_07.tres"),
	preload("res://data/cards/card_08.tres"),
	preload("res://data/cards/card_09.tres"),
	preload("res://data/cards/card_10.tres"),
	preload("res://data/cards/card_11.tres"),
	preload("res://data/cards/card_12.tres"),
]

func get_random_deck(count: int) -> Array[CardData]:
	var shuffled = all_cards.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
