import random
from Card import Card

class Deck:
    def __init__(self):
        self.cards = [
            Card(2, "Heart", "H2"),
            Card(3, "Heart", "H3"),
            Card(4, "Heart", "H4"),
            Card(5, "Heart", "H5"),
            Card(6, "Heart", "H6"),
            Card(7, "Heart", "H7"),
            Card(8, "Heart", "H8"),
            Card(9, "Heart", "H9"),
            Card(10, "Heart", "H10"),
            Card(10, "Heart", "HJ"),
            Card(10, "Heart", "HQ"),
            Card(10, "Heart", "HK"),
            Card(11, "Heart", "HA"),
            Card(2, "Diamond", "D2"),
            Card(3, "Diamond", "D3"),
            Card(4, "Diamond", "D4"),
            Card(5, "Diamond", "D5"),
            Card(6, "Diamond", "D6"),
            Card(7, "Diamond", "D7"),
            Card(8, "Diamond", "D8"),
            Card(9, "Diamond", "D9"),
            Card(10, "Diamond", "D10"),
            Card(10, "Diamond", "DJ"),
            Card(10, "Diamond", "DQ"),
            Card(10, "Diamond", "DK"),
            Card(11, "Diamond", "DA"),
            Card(2, "Club", "C2"),
            Card(3, "Club", "C3"),
            Card(4, "Club", "C4"),
            Card(5, "Club", "C5"),
            Card(6, "Club", "C6"),
            Card(7, "Club", "C7"),
            Card(8, "Club", "C8"),
            Card(9, "Club", "C9"),
            Card(10, "Club", "C10"),
            Card(10, "Club", "CJ"),
            Card(10, "Club", "CQ"),
            Card(10, "Club", "CK"),
            Card(11, "Club", "CA"),
            Card(2, "Spade", "S2"),
            Card(3, "Spade", "S3"),
            Card(4, "Spade", "S4"),
            Card(5, "Spade", "S5"),
            Card(6, "Spade", "S6"),
            Card(7, "Spade", "S7"),
            Card(8, "Spade", "S8"),
            Card(9, "Spade", "S9"),
            Card(10, "Spade", "S10"),
            Card(10, "Spade", "SJ"),
            Card(10, "Spade", "SQ"),
            Card(10, "Spade", "SK"),
            Card(11, "Spade", "SA") 
        ]
        random.shuffle(self.cards)
    
    
    def get_three_cards(self):
        new_cards = [
            self.cards.pop(),
            self.cards.pop(),
            self.cards.pop()
        ]
        return new_cards
