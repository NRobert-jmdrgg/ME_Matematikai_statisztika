

class Card:
    def __init__(self, value, suit, ID):
        self.value = value
        self.suit = suit
        self.ID = ID
    
    def __str__(self):
        return "" + self.ID
    
    @staticmethod    
    def get_min(a, b):
        if a.value <= b.value:
            return a
        else:
            return b
    
    @staticmethod    
    def get_max(a, b):
        if a.value >= b.value:
            return a
        else:
            return b
    
    @staticmethod    
    def get_min_from_arr(cards):
        min_card = cards[0]
        for i in range(1, len(cards)):
            if cards[i].value < min_card.value:
                min_card = cards[i]
        return min_card

    @staticmethod    
    def get_max_from_arr(cards):
        max_card = cards[0]
        for i in range(1, len(cards)):
            if cards[i].value > max_card.value:
                max_card = cards[i]
        return max_card