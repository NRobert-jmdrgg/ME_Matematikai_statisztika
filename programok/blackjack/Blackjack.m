function Blackjack(n)
    deck = getCards();
    % keverés
    deck = deck(randperm(length(deck)));
    
    dealer = struct('name', 'dealer', 'hand', getHand(), 'chips', 100000)

    c = 'A';
    for i = 1 : n
        players(i) = struct('name', char(c), 'hand', getHand(), 'chips', 100);
        c = c + 1;
    end
    
    for player = players
        player
    end
    
    function hand = getHand()
        hand(1) = deck(1);
        hand(2) = deck(2);
        deck(1) = [];
        deck(2) = [];
    end 
end