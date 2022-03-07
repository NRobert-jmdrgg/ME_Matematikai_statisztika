

from random import Random
import random
from Card import Card


class Player:
    
    
    def __init__(self, name, lives):
        self.name = name
        self.lives = lives
        self.cards = None
        self.dominant_suit = None
        self.still_in_game = True
        self.knocked = False
        
        
    def __str__(self):
        return self.name + ", " + self.cards[0].ID + ", " + self.cards[1].ID + ", " + self.cards[2].ID + ", " + str(self.lives) + ", " + str(self.get_hand_value())
    
    def set_new_cards(self, cards):
        self.cards = cards
        self.decide_dominant_suit()
    
    def decide_dominant_suit(self):
        if self.cards[0].suit == self.cards[1].suit or self.cards[0].suit == self.cards[2].suit:
            self.dominant_suit = self.cards[0].suit
        elif self.cards[1].suit == self.cards[2].suit:
            self.dominant_suit = self.cards[1].suit
    
    def get_hand_value(self):
        if self.dominant_suit is not None:
            sum = 0
            for i in range(3):
                if self.cards[i].suit == self.dominant_suit:
                    sum += self.cards[i].value
            return sum
        else:
            return Card.get_max_from_arr(self.cards).value
    
    def get_number_of_dominant_cards(self):
        count = 0
        for i in range(3):
            if self.cards[i].suit == self.dominant_suit:
                count = count + 1
        return count
    
    def get_dominant_card_sum(self):
        sum = 0
        for card in self.cards:
            if card.suit == self.dominant_suit:
                sum += card.value
        return sum
    
    def decide_card_to_swap(self, new_card):
        hand_value = self.get_hand_value()
        card_to_swap = None
        min_card = Card.get_min_from_arr(self.cards)
        dominant_card_value_sum = self.get_dominant_card_sum()
        
        s_index = None
        match self.get_number_of_dominant_cards():
            case 0:
                for i in range(3):
                    if self.cards[i].suit == new_card.suit:
                        s_index = i
                        break
                if s_index is None: 
                    if min_card.value < new_card.value:
                        card_to_swap = min_card
                else:
                    sum_of_cards = self.cards[s_index].value + new_card.value
                    indexes = [0, 1, 2]
                    indexes.remove(s_index)
                    min_card = Card.get_min(self.cards[indexes[0]], self.cards[indexes[1]])
                    if min_card.value < sum_of_cards:
                        card_to_swap = min_card
            case 2:
                if new_card.suit == self.dominant_suit:
                    for i in range(3):
                        if self.cards[i].suit != self.dominant_suit:
                            nd_index = i
                            break
                    
                    if self.cards[nd_index].value < dominant_card_value_sum + new_card.value:
                        card_to_swap = self.cards[nd_index]
                else:
                    for i in range(3):
                        if self.cards[i].suit != self.dominant_suit:
                            indexes = [0, 1, 2]
                            indexes.remove(i)
                            if self.cards[i].suit == new_card.suit:
                                val = self.cards[i].value + new_card.value
                                sum = self.cards[indexes[0]].value + self.cards[indexes[1]].value
                                if val > sum:
                                    card_to_swap = Card.get_min(self.cards[indexes[0]], self.cards[indexes[1]])
                                elif new_card.value > self.cards[i].value:
                                    card_to_swap = self.cards[i]
                            elif self.cards[i].value < new_card.value:
                                card_to_swap = self.cards[i]                 
            case 3:
                if (new_card.suit != self.dominant_suit and new_card.value > hand_value) or \
                    (new_card.suit == self.dominant_suit and new_card.value > min_card.value):
                    card_to_swap = min_card
                    
        return card_to_swap
    
    def swap(self, cards, discarded_cards):
        card_to_swap = self.decide_card_to_swap(discarded_cards[len(discarded_cards) - 1])
        if card_to_swap is not None:
            temp = card_to_swap
            self.cards.remove(card_to_swap)
            self.cards.append(discarded_cards.pop())
            discarded_cards.append(temp)
        else:
            card_to_swap = self.decide_card_to_swap(cards[len(cards) - 1])
            if card_to_swap is not None:
                temp = card_to_swap
                self.cards.remove(card_to_swap)
                self.cards.append(cards.pop())
                discarded_cards.append(temp)
            else:
                discarded_cards.append(cards.pop())
                return False
        return True
    
    def decide_to_knock(self, cycle_number):
        hand_value = self.get_hand_value()
        if hand_value == 31:
            return True
        
        if cycle_number < 3 and cycle_number >= 1:
            div = cycle_number + 1
        else:
            div = 4
            
        if hand_value <= 15:
            knock_chance = ( hand_value / 31 ) / div
        else:
            knock_chance = ( hand_value / 31 ) 
            
        f = random.uniform(0, 1)
        if f < knock_chance:
            self.knocked = True
            return True
        
        return False
        
    @staticmethod    
    def reset_players():
        return [
            Player("A", 5),
            Player("B", 5),
            Player("C", 5),
            Player("D", 5),
            Player("E", 5),
            Player("F", 5),
            Player("G", 5)
        ]


