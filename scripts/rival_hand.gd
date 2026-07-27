extends Node

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_WIDTH = 100
const HAND_Y_POSITION = 1000
const HAND_OFFSET_FROM_CENTER = 600

var rival_hand = []
var center_screen_x

@export var rival_slot_path: NodePath
@onready var rival_slot = get_node(rival_slot_path)

func _ready() -> void:
	center_screen_x = get_viewport().size.x/2
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.setup(CardDatabase.rival_hand_cards[i])
		new_card.hide_from_player()
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in rival_hand:
		rival_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.starting_position)

func update_hand_positions():
	for i in range(rival_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = rival_hand[i]
		animate_card_to_position(card, new_position)
		card.starting_position = new_position

func calculate_card_position(index):
	var total_width = (HAND_COUNT - 1) * CARD_WIDTH
	var hand_center_x = center_screen_x - HAND_OFFSET_FROM_CENTER
	var x_offset = hand_center_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func replenish() -> void:
	var card_scene = preload(CARD_SCENE_PATH)
	var cards_needed = HAND_COUNT - rival_hand.size()
	if cards_needed <= 0:
		return
	var new_cards = CardDatabase.get_random_deck(cards_needed)
	for card_data in new_cards:
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.setup(card_data)
		new_card.hide_from_player()
		add_card_to_hand(new_card)

func play_random_card() -> void:
	if rival_hand.is_empty():
		return
	var random_index = randi() % rival_hand.size()
	var chosen_card = rival_hand[random_index]
	rival_hand.remove_at(random_index)
	animate_card_into_slot(chosen_card, rival_slot)
	update_hand_positions()

func animate_card_into_slot(card, slot) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", slot.position, 0.4)
	tween.tween_property(card, "scale", slot.CARD_TARGET_SCALE, 0.4)
	tween.set_parallel(false)
	tween.tween_callback(func():
		card.place_in_slot(slot)
		slot.card_in_slot = true
		slot.placed_card = card
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
