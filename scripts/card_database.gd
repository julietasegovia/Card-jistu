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
	preload("res://data/cards/crad_13.tres"),
	preload("res://data/cards/card_14.tres"),
	preload("res://data/cards/card_15.tres"),
	preload("res://data/cards/card_16.tres"),
	preload("res://data/cards/card_17.tres"),
	preload("res://data/cards/card-18.tres"),
	preload("res://data/cards/card_19.tres"),
	preload("res://data/cards/card_20.tres"),
	preload("res://data/cards/card_21.tres"),
]

var player_hand_cards: Array[CardData] = []
var rival_hand_cards: Array[CardData] = []

func deal_hands() -> void:
	var shuffled = all_cards.duplicate()
	shuffled.shuffle()
	player_hand_cards = shuffled.slice(0, 5)
	rival_hand_cards = shuffled.slice(5, 10)

func get_random_deck(count: int) -> Array[CardData]:
	var shuffled = all_cards.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
