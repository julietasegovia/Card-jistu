extends Node2D

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_WIDTH = 100
const HAND_Y_POSITION = 1000

var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x/2
	
	var card_scene = preload(CARD_SCENE_PATH)
	var dealt_cards = CardDatabase.get_random_deck(HAND_COUNT)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "CARD"
		new_card.setup(dealt_cards[i])
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.starting_position)

func update_hand_positions(): #when a card is selected, the cards in hand's position
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card, new_position)
		card.starting_position = new_position

func calculate_card_position(index):
	var total_width = player_hand.size() -1 * CARD_WIDTH
	var x_offset = (1.45 * center_screen_x) + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
