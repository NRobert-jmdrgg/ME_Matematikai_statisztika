function Blackjack(number_of_players, number_of_decks)
    % input check
    if number_of_players > 26 
        fprintf('Tul sok jatekos\n');
        return ;
    elseif number_of_players < 1
        fprintf('Nem eleg jatekos\n');
        return ;
    elseif number_of_decks > 7
        fprintf('Tul sok kartya\n');
        return ;
    elseif number_of_decks < 1
        fprintf('Tul keves kartya\n');
        return ;
    end

    % jatekosok definialasa
    players = struct([]);
    names = 'A' : 'Z';
    for i = 1 : number_of_players
        players(i).name = names(i);
        players(i).active = true;
        players(i).alreadyPaid = false;
        players(i).chips = 1000;
        players(i).bet = 0;
    end

    deck__ = getCards(number_of_decks);

    bet_amounts = [5, 25, 50, 100, 500];
    number_of_players_still_in_game = number_of_players;
    % main loop
    while number_of_players_still_in_game > 0
        % kártyák elokeszitese
        deck = deck__;
        deck = deck(randperm(length(deck)));
    
        dealerHand = getCardsFromDeck(2);
        % minden jatekos fogad
        for i = 1 : number_of_players
            if players(i).active == true
                biggest_bet_value = getBiggestPossibleBet(bet_amounts, players(i).chips);
            
                if biggest_bet_value > 0
                    b = randsample(bet_amounts(1:biggest_bet_value), 1);
                    players(i).bet = b;
                    players(i).chips = players(i).chips - b;
                end
                fprintf('%c fogadott %d maradt neki %d\n', players(i).name, players(i).bet, players(i).chips);
            end
            
        end

        % minden játékos kap két lapot
        for i = 1 : number_of_players
            if players(i).active == true
                players(i).hand = getCardsFromDeck(2);
                fprintf('%c keze:\n', players(i).name);
                players(i).hand
            end
        end



        % dontse el, hogy a játékos hit / stand / doube 
        for i = 1 : number_of_players
            if players(i).active == true
                hv = getHandValue(players(i).hand);
                if hv <= 10                                                     % ha a kezunk erteke 10 vagy kissebb, akkor húzunk egy új kártyát
                    players(i).hand(length(players(i).hand) + 1) = getCardsFromDeck(1);
                elseif hv == 11 && players(i).chips > (players(i).bet * 2)      % double down
                    players(i).hand(length(players(i).hand) + 1) = getCardsFromDeck(1);
                    players(i).chips = players(i).chips - players(i).bet;
                    players(i).bet = players(i).bet * 2;
                    % fprintf('%c duplazott: %d maradt neki %d kartyai\n', players(i).name, players(i).bet, players(i).chips);
                    % players(i).hand
                end    
            end
        end

        % ha minden jatekos keszen all, akkor a dealer huz uj kartyakat, ameddig a keze 17 nem lesz
        while sum(dealerHand) < 17
            dealerHand(length(dealerHand) + 1) = getCardsFromDeck(1);
        end

        % nézzük meg, hogy a dealer keze nagyobb-e, mint 21
        dhv = sum(dealerHand);
        for i = 1 : number_of_players
            hv = getHandValue(players(i).hand);
            if hv == 21
                players(i).chips = players(i).chips + ceil(players(i).bet * 2.5);
                players(i).alreadyPaid = true;
            end
        end

        if dhv > 21
            for i = 1 : number_of_players
                if players(i).active == true && players(i).alreadyPaid == false
                    players(i).chips = players(i).chips + ceil(players(i).bet * 2);
                end
            end
        else
            for i = 1 : number_of_players
                hv = getHandValue(players(i).hand);
                if players(i).active == true && players(i).alreadyPaid == false && hv > dhv
                    players(i).chips = players(i).chips + ceil(players(i).bet * 2);
                end
            end
        end

        players([1:number_of_players]).alreadyPaid = false;

        % nezzuk meg, hogy melyik jatekosoknak van meg penze.
        for i = 1 : number_of_players
            if players(i).chips > bet_amounts(1) 
                players(i).active = true;
            elseif players(i).chips < bet_amounts(1) && players(i).active == true
                number_of_players_still_in_game = number_of_players_still_in_game - 1;
                players(i).hand = [];
                players(i).active = false;
            end
        end
    end

    fprintf('Jatek vege: Elemzes:\n');
    for i = 1 : number_of_players
        fprintf('nev: %c maradek penz: %d\n', players(i).name, players(i).chips);
    end

    % adj n darab kártyát a pakliból
    function cards = getCardsFromDeck(n)
        cards = zeros(n, 1);
        for j = 1 : n
            cards(j) = deck(1);
            deck(1) = [];
            
        end     
    end

    % a lapok értéke
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

    % legnagyobb fogadás érték
    function value = getBiggestPossibleBet(bet_values, avaliable_money)
        n = length(bet_values);
        value = 0;
        for j = n : -1 : 1
            if avaliable_money > bet_values(j)
                value = j;
                break;
            end
        end

    end
end