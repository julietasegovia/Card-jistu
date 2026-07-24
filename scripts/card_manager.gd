extends Node2D

const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_CARD = 1
const CARD_BASE_SCALE = Vector2(1,1)
const SCALE_LERP_RADIUS = 250

var card_dragged
var screen_size
var is_hovering_on_card
var player_hand_reference

@export var turn_manager_path: NodePath
@onready var turn_manager = get_node(turn_manager_path)

func _ready() -> void:
		screen_size = get_viewport_rect().size
		player_hand_reference = $"../PlayerHand"

func _process(delta: float) -> void:
	if card_dragged:
		var mouse_pos = get_global_mouse_position()
		card_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y)) 
		update_drag_scale(card_dragged)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = check_for_card()
			if card:
				start_drag(card)
		else:
			finish_drag()

func start_drag(card):
	card_dragged = card
	card.scale = Vector2(1,1)

func finish_drag():
	if not card_dragged:
		return
	var card_slot_found = check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		card_dragged.position = card_slot_found.position
		card_dragged.place_in_slot(card_slot_found)
		card_slot_found.card_in_slot = true
		card_slot_found.placed_card = card_dragged
		player_hand_reference.player_hand.erase(card_dragged)
		turn_manager.stop_turn_timer()
	else:
		player_hand_reference.add_card_to_hand(card_dragged)
		card_dragged.scale = Vector2(1.05, 1.05)
	card_dragged = null

func check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_on_top(result)
	return null

func check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

# for the user to be only able to select the card on top of a stack 
func get_card_on_top(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index

	for i in range(1, cards.size()):
		var current_card = cards[1].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func connect_card_signals(card):
		card.connect("hovered", on_hovered_over_card)
		card.connect("hovered_off", off_hovered_over_card)
		
func highlight_card(card, hovered):
	if card.is_placed_in_slot:
		return
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 3
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

func off_hovered_over_card(card):
	if !card_dragged:
		highlight_card(card, false)
		# in case user goes straight into another card
		var new_card_hovered = check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func update_drag_scale(card):
	var nearest_slot = get_nearest_empty_slot(card.global_position)
	if nearest_slot:
		var distance = card.global_position.distance_to(nearest_slot.global_position)
		var t = 1.0 - clamp(distance/SCALE_LERP_RADIUS, 0.0, 1.0)
		card.scale = CARD_BASE_SCALE.lerp(nearest_slot.CARD_TARGET_SCALE, t)
	else:
		card.scale = CARD_BASE_SCALE

func get_nearest_empty_slot(pos):
	var slots = get_tree().get_nodes_in_group("card_slot")
	var nearest = null
	var nearest_dist = INF
	for slot in slots:
		if slot.card_in_slot:
			continue
		var d = pos.distance_to(slot.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = slot
	return nearest
