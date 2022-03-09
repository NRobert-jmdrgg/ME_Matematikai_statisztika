function test()
    cards = getCards(1);
    cards = cards(randperm(length(cards)));
    for i = 1 : length(cards)
        fprintf('%d %s\n', cards(i).value, cards(i).suit);
    end


end