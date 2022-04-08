function test()
    hand = {[], [], [], []};
    number_of_hands = 1;
    % pakli kártya előkészítése
    deck = getCards(6);
    % pakli keverése
    deck = deck(randperm(length(deck)));

    dealerHand(1).value = 6;
    dealerHand(1).name = 'six';
    dealerHand(1).suit = 'Diamond';
    
    dealerHand(2).value = 3;
    dealerHand(2).name = 'three';
    dealerHand(2).suit = 'Heart';
    

    k = 1;

    hand{1}(1).value = 11; 
    hand{1}(1).name = 'ace';
    hand{1}(1).suit = 'Heart';
    
    hand{1}(2).value = 11; 
    hand{1}(2).name = 'ace';
    hand{1}(2).suit = 'Diamond';
    

    while k <= number_of_hands
        % megnezzuk hogy a játékos k-adik keze páros pl 3-3 lapok
        if checkIfPair(hand{k})
            % split esetén új fogadás és kéz lesz.
            if decideToSplit1(dealerHand, hand, k)
                % Ha aszt splitelunk akkor nincs hit es blackjack
                if hand{k}(1).value == 11 && hand{k}(2).value == 11
                    canHit = false;
                    canBlackjack = false;
                end

                % jatekos 2 uj lapot
                hand{number_of_hands + 1}(1).value = hand{k}(2).value;
                hand{number_of_hands + 1}(1).name = hand{k}(2).name;
                hand{number_of_hands + 1}(1).suit = hand{k}(2).suit;
                hand{number_of_hands + 1}(2) = getCardsFromDeck(1);
                hand{k}(2) = getCardsFromDeck(1);
                number_of_hands = number_of_hands + 1;
                % ujrakezdjuk a kezek vizsgalatat
                k = 1;
            else
                k + k + 1;
            end
        else 
            k = k + 1;
        end
    end 

    fprintf('jatekos keze:\n');

    for k = 1:number_of_hands
        fprintf('%d. kez\n', k);
        for i = 1:length(hand{k})
            disp(hand{k}(i));
        end
    end

    function val = decideToSplit1(dealerHand, hand, k)
        val = false;

        if (hand{k}(1).value == 11) || ...
                (value_between(2, 6, dealerHand(1).value) && value_between(6, 9, hand{k}(1).value)) || ...
                (dealerHand(1).value == 7 && value_between(7, 8, hand{k}(1).value)) || ...
                (value_between(8, 9, dealerHand(1).value) && value_between(8, 9, hand{k}(1).value)) || ...
                (dealerHand(1).value == 10 && hand{k}(1).value == 8) || ...
                (value_between(5, 6, dealerHand(1).value) && hand{k}(1).value == 4) || ...
                (value_between(2, 7, dealerHand(1).value) && value_between(2, 3, hand{k}(1).value)) || ...
                (dealerHand(1).value == 11 && hand{k}(1).value == 8)
            val = true;
        end

    end

    function cards = getCardsFromDeck(n)

        cards = struct('value', 0, 'name', '', 'suit', '');

        for j = 1:n
            cards(j) = deck(end);
            % a tombot stack-kent kezeljuk
            deck(end) = [];
        end
    end
end