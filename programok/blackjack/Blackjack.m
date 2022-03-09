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

    % adatgyujteshez
    data = struct([]);
    for i = 1 : number_of_players
        data(i).name = names(i);
        data(i).chipsPerRound = [];
        data(i).hanValuePerRound = [];
    end
    averageChipsPerRound = [];
    
    deck = getCards(number_of_decks);
    deck = deck(randperm(length(deck)));
    bet_amounts = [5, 25, 50, 100, 500];
    number_of_players_still_in_game = number_of_players;
    % main loop
    round_counter = 0;
    while number_of_players_still_in_game > 0
        round_counter = round_counter + 1;
        % kártyák elokeszitese  
        dealerHand = getCardsFromDeck(2);
        
        for i = 1 : number_of_players
            if players(i).active == true
                % minden jatekos fogad
                biggest_bet_value = getBiggestPossibleBet(bet_amounts, players(i).chips);
                
                if biggest_bet_value > 0
                    b = randsample(bet_amounts(1:biggest_bet_value), 1);
                    players(i).bet = b;
                    players(i).chips = players(i).chips - b;
                end
                % fprintf('%c fogadott %d maradt neki %d\n', players(i).name, players(i).bet, players(i).chips);

                % minden játékos kap két lapot
                players(i).hand = getCardsFromDeck(2);
                % fprintf('%c keze:\n', players(i).name);
                % players(i).hand

                % dontse el, hogy a játékos hit / stand / doube 
                hv = getHandValue(players(i).hand);
                if hv <= 10                                                     % ha a kezunk erteke 10 vagy kissebb, akkor húzunk egy új kártyát
                    players(i).hand(length(players(i).hand) + 1) = getCardsFromDeck(1);
                elseif hv == 11 && players(i).chips > (players(i).bet * 2)      % double down
                    players(i).hand(length(players(i).hand) + 1) = getCardsFromDeck(1);
                    players(i).chips = players(i).chips - players(i).bet;
                    players(i).bet = players(i).bet * 2;
                    % fprintf('%c duplazott: %d maradt neki %d kartyai\n', players(i).name, players(i).bet, players(i).chips);
                    % players(i).hand'
                end
            end
            data(i).chipsPerRound(round_counter) = players(i).chips;
            
            % if players(i).active == true
            %     fprintf('%c ertek: %d keze:\n', players(i).name, getHandValue(players(i).hand));
            %     players(i).hand'
            % end
        end

        
        % ha minden jatekos keszen all, akkor a dealer huz uj kartyakat, ameddig a keze 17 nem lesz
        while getHandValue(dealerHand) < 17
            dealerHand(length(dealerHand) + 1) = getCardsFromDeck(1);
        end
        
        % megnezzuk kinek lett 21 a keze
        for i = 1 : number_of_players
            
            hv = getHandValue(players(i).hand);
            if hv == 21 
                players(i).chips = players(i).chips + ceil(players(i).bet * 2.5);
                players(i).alreadyPaid = true;
            end
            
        end
        
        % kifizetes
        dhv = getHandValue(dealerHand);
        % fprintf('dealer ertek: %d keze:', dhv);
        % dealerHand'

        if dhv > 21
            for i = 1 : number_of_players
                if players(i).active == true && players(i).alreadyPaid == false
                    players(i).chips = players(i).chips + ceil(players(i).bet * 2);
                end
            end
        else
            for i = 1 : number_of_players
                hv = getHandValue(players(i).hand);
                if players(i).alreadyPaid == false && hv > dhv
                    players(i).chips = players(i).chips + ceil(players(i).bet * 2);
                end
            end
        end

        % nezzuk meg, hogy melyik jatekosoknak van meg penze.
        for i = 1 : number_of_players
            if players(i).chips > bet_amounts(1) 
                players(i).active = true;
            elseif players(i).chips < bet_amounts(1) && players(i).active == true
                number_of_players_still_in_game = number_of_players_still_in_game - 1;
                fprintf('Kiesett: %c %d\n', players(i).name, players(i).chips);
                players(i).hand = [];
                players(i).active = false;
                
            end
            players(i).alreadyPaid = false;
        end
    end

    for k = 1 : round_counter
        s = 0;
       for i = 1 : number_of_players
            s = s + data(i).chipsPerRound(k);
       end
       averageChipsPerRound(k) = s / number_of_players;
    end
    
    % plot
    averageChipsAllGame = mean([averageChipsPerRound]);
    hold on;
    % set(gca, 'Xtick', 0:1:round_counter, 'Ytick', 0:5:10000)
    for i = 1 : number_of_players
        plot(data(i).chipsPerRound)
    end 
    plot(averageChipsPerRound)
    line([0 round_counter], [averageChipsAllGame averageChipsAllGame])
    legend({data(:).name, 'Atlag / kor', 'Teljes atlag'}, 'Location', 'northeast');
    
    
    % fprintf('Jatek vege: Elemzes:\n');
    % for i = 1 : number_of_players
    %     fprintf('nev: %c maradek penz: %d\n', players(i).name, players(i).chips);
    % end

    % adj n darab kártyát a pakliból
    function cards = getCardsFromDeck(n)
        if length(deck) < 2
            deck = getCards(number_of_decks);
        end

        cards = struct('value', 0, 'suit', '');
        for j = 1 : n
            cards(j) = deck(1);
            deck(1) = [];
            
        end     
    end

    % a lapok értéke
    function value = getHandValue(cards)
        value = 0;
        if ~isempty(cards)
            value = sum([cards.value]);
            if value > 21
                for card = cards
                    if card.value == 11
                        value = value - 10;
                    end
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