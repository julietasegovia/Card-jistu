extends Node

signal turn_resolved(winner: Winner)
signal round_over(winner_name: String)

const WINS_NEEDED = 3

enum Winner { PLAYER, RIVAL, TIE }

# key beats value: ICE beats WATER, WATER beats FIRE, FIRE beats ICE
const BEATS = {
	CardData.Type.ICE: CardData.Type.WATER,
	CardData.Type.WATER: CardData.Type.FIRE,
	CardData.Type.FIRE: CardData.Type.ICE,
}

var player_wins = 0
var rival_wins = 0

func resolve_turn(player_card: CardData, rival_card: CardData) -> Winner:
	var winner = get_turn_winner(player_card, rival_card)
	match winner:
		Winner.PLAYER:
			player_wins += 1
		Winner.RIVAL:
			rival_wins += 1
	turn_resolved.emit(winner)
	check_for_round_winner()
	return winner

func get_turn_winner(player_card: CardData, rival_card: CardData) -> Winner:
	if player_card.type == rival_card.type:
		if player_card.power > rival_card.power:
			return Winner.PLAYER
		elif rival_card.power > player_card.power:
			return Winner.RIVAL
		else:
			return Winner.TIE
	elif BEATS[player_card.type] == rival_card.type:
		return Winner.PLAYER
	else:
		return Winner.RIVAL

func check_for_round_winner():
	if player_wins >= WINS_NEEDED:
		round_over.emit("player")
	elif rival_wins >= WINS_NEEDED:
		round_over.emit("rival")
