function Blackjack(number_of_players, number_of_decks)
    deck = getCards(number_of_decks);
    % keverés
    deck = deck(randperm(length(deck)));
    
    dealer.name = 'dealer';
    dealer.hand = getCardsFromDeck(2);
    
    % jatekosok definialasa
    players = struct([]);
    names = 'A' : 'Z';
    for i = 1 : number_of_players
        players(i).name = names(i);
        players(i).hand_1 = getCardsFromDeck(2);
        players(i).hand_2 = [];
        players(i).chips = 1000;
    end

    % dontse el, hogy a játékos hit / stand / doube 
    for i = 1 : number_of_players
        hv = getHandValue(players(i).hand_1);     
        if hv <= 10     % ha a kezunk erteke 10 vagy kissebb, akkor húzunk egy új kártyát
            players(i).hand_1(length(players(i).hand_1) + 1) = getCardsFromDeck(1);
        elseif hv == 11 % double down
            players(i).hand_1(length(players(i).hand_1) + 1) = getCardsFromDeck(1);
        end    
    end

    % ha minden jatekos keszen all, akkor a dealer huz uj kartyakat, ameddig a keze 17 nem lesz
    dealer.hand;
    while sum(dealer.hand) < 17
        dealer.hand(length(dealer.hand) + 1) = getCardsFromDeck(1);
    end

    % nézzük meg, hogy a dealer keze nagyobb-e, mint 21
    if sum(dealer.hand) > 21
        fprintf('A dealer keze nagyobb, mint 21, ezert minden jatekos nyer');
        return ;
    end

    function cards = getCardsFromDeck(n)
        cards = zeros(n, 1);
        for j = 1 : n
            cards(j) = deck(1);
            deck(1) = [];
            
        end     
    end

    function value = getHandValue(cards)
        value = sum(cards);
        if value > 21
            for card = cards
                if card == 11
                    value = value - 10;
                end
            end
        end
    end        


end