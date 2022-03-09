function cards = getCards(number_of_decks)
    x = [2 3 4 5 6 7 8 9 10 10 10 10 11];
    suits = {'Club', 'Diamond', 'Heart', 'Spade'};
    
    j = 1;
    s = 1;
    for i = 1 : 52 * number_of_decks
        if s > 4
            s = 1;
        end
        cards(i).value = x(j);
        cards(i).suit = suits{s};
        j = j + 1;
        if mod(i, 13) == 0
            s = s + 1;
            j = 1;
        end 
    end
end