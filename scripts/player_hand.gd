extends Node2D

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_WIDTH = 100
const HAND_Y_POSITION = 1000
const HAND_OFFSET_FROM_CENTER = 600

var player_hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
	CardDatabase.deal_hands()
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "CARD"
		new_card.setup(CardDatabase.player_hand_cards[i])
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
	var total_width = (HAND_COUNT - 1) * CARD_WIDTH
	var hand_center_x = center_screen_x + HAND_OFFSET_FROM_CENTER
	var x_offset = hand_center_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func replenish() -> void:
	var card_scene = preload(CARD_SCENE_PATH)
	var cards_needed = HAND_COUNT - player_hand.size()
	if cards_needed <= 0:
		return
	var new_cards = CardDatabase.get_random_deck(cards_needed)
	for card_data in new_cards:
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "CARD"
		new_card.setup(card_data)
		add_card_to_hand(new_card)
