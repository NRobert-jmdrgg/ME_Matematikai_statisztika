

from Card import Card
from Deck import Deck
from Player import Player
    
stack_of_cards = None

# def get_knocker(players):
#     for i in len(players):
#         if players[i].knocked == True:
#             return i
#     return None

def get_min_hand_value(players):
    min = players[0].get_hand_value()
    for i in range(1, len(players)):
        val = players[i].get_hand_value()
        if val < min:
            min = val
    return min

def start_round(players, cards, discarded_cards):
    round_ended = False
    cycles = 0
    while round_ended == False:
        cycles += 1
        knocker_index = None
        for i in range(len(players)):
            if players[i].decide_to_knock(cycles) == True:
                knocker_index = i
                break
            # if players[i].swap(cards[len(cards)]) == False:
            #     players[i].swap(discarded_cards[len(discarded_cards)])
        
        
        if knocker_index is not None:
            for i in range(len(players)):
                if i != knocker_index:
                    pass # swap
                    # if players[i].swap(cards[len(cards)]) == False:
                    # players[i].swap(discarded_cards[len(discarded_cards)])
                    
            min_hand_val = get_min_hand_value(players)
            for i in range(len(players)):
                if players[i].get_hand_value() == min_hand_val:
                    if i == knocker_index:
                        players[i].lives -= 2
                    else:
                        players[i].lives -= 1
            round_ended = True
     
            

def main():   
    discarded_cards = []
    max_number_of_games = 1
    game_counter = 0
    number_of_active_players = 7
    
    stack_of_cards = Deck()
    discarded_cards.append(stack_of_cards.cards.pop())
    p = Player("A", 5)
    p.set_new_cards(stack_of_cards.get_three_cards())
    
    print(p, str(p.dominant_suit))
    print("stack kartya " + str(stack_of_cards.cards[len(stack_of_cards.cards) - 1]))
    print("eldobott kartyak: ")
    for i in discarded_cards:
        print(i)
    print(p.swap(stack_of_cards.cards, discarded_cards))
    print(p, str(p.dominant_suit))
    print("eldobott kartyak: ")
    for i in discarded_cards:
        print(i)
    # while game_counter < max_number_of_games:
    #     game_counter += 1
    #     stack_of_cards = Deck()
    #     players = Player.reset_players()
    #     for i in range(len(players)):
    #         players[i].cards = stack_of_cards.get_three_cards()
    #         players[i].decide_dominant_suit()
        
    #     while number_of_active_players > 1:
    #         pass # start_round(players, stack_of_cards, discarded_cards)
        
                
                
if __name__ == "__main__":
    main()
    
