function cards = getCards(number_of_decks)
    x = [2 3 4 5 6 7 8 9 10 10 10 10 11 2 3 4 5 6 7 8 9 10 10 10 10 11 2 3 4 5 6 7 8 9 10 10 10 10 11 2 3 4 5 6 7 8 9 10 10 10 10 11];
    cards = [];
    
    for i = 1 : number_of_decks
        cards = horzcat(cards, x);
    end
end