function Blackjack(number_of_decks, money, number_of_rounds, strategy)
    % input check
    if number_of_decks > 8
        fprintf('Tul sok kartya\n');
        return;
    elseif number_of_decks < 1
        fprintf('Tul keves kartya\n');
        return;
    end
    if money < 1
        fprintf('Tul keves fogadas penz\n');
        return;
    end
    if number_of_rounds < 1
        fprintf('Tul keves kor\n');
        return;
    end

    deck = getCards(number_of_decks);
    deck = deck(randperm(length(deck)));
    dealerHand = getCardsFromDeck(2);
    hand = {[], [], [], []};
    hand{1} = getCardsFromDeck(2);
    max_number_of_hands = 4;
    number_of_hands = 1;
    
    fprintf('dealer hand:\n');
    for i = 1 : 2
        disp(dealerHand(i));
    end

    fprintf('player hand:\n');

    k = 1;
    while k <= number_of_hands
        if checkIfPair(hand{k})
            if decideToSplit1(dealerHand, hand, k) 
                hand{i}(1).value = hand{k}(2).value;
                hand{i}(1).suit = hand{k}(2).suit;
                hand{i}(2) = getCardsFromDeck(1);
                hand{k}(2) = getCardsFromDeck(1);
                number_of_hands = number_of_hands + 1;
                k = 1;
            elseif decideToHit1(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
                k = k + 1;
            elseif decideToDoubleDown1(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
                k = k + 1;
            else
                k = k + 1;
            end        
        elseif checkIfHasAce(hand{k})
            if decideToDoubleDown2(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
            elseif decideToHit2(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
            end
            k = k + 1;
        else
            if decideToDoubleDown3(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
            elseif decideToHit3(dealerHand, hand, k)
                hand{k}(3) = getCardsFromDeck(1);
            end
            k = k + 1;
        end
    end

    for k = 1 : number_of_hands
        fprintf('%d adik kez\n', k);
        for i = 1 : length(hand{k})
            disp(hand{k}(i));
        end
    end
    if checkIfPair(hand{1})
        decideToSplit1(dealerHand, hand, 1)
    end

    function val = decideToSplit1(dealerHand, hand, k)
        val = false;
        if (hand{k}(1).value == 11) || ...
         (value_between(2, 6, dealerHand(1).value) && value_between(6, 9, hand{k}(1).value)) || ...
         (dealerHand(1).value == 7 && value_between(7, 8, hand{k}(1).value)) || ...
         (value_between(8, 9, dealerHand(1).value) && value_between(8, 9, hand{k}(1).value)) || ...
         (dealerHand(1).value == 10 && hand{k}(1).value == 8) || ...
         (value_between(5, 6, dealerHand(1).value) && hand{k}(1).value == 4) || ...
         (value_between(2, 7, dealerHand(1).value) && value_between(2, 3, hand{k}(1).value)) 
            val = true;
        end
    end

    function val = decideToHit1(dealerHand, hand, k)
        val = false;
        if (value_between(2, 7, hand{k}(1).value) && value_between(10, 11, dealerHand(1).value)) || ...
            (value_between(6, 7, hand{k}(1).value) && value_between(8, 9, dealerHand(1).value)) || ...
            (value_between(2, 4, hand{k}(1).value) && value_between(8, 9, dealerHand(1).value)) || ...
            ((hand{k}(1).value == 6 || hand{k}(1).value == 4) && dealerHand(1).value == 7) || ...
            (hand{k}(1).value == 4 && value_between(2, 4, dealerHand(1).value))
                val = true; 
        end
    end

    function val = decideToHit2(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});
        if (hv == 18 && value_between(9, 11, dealerHand(1).value)) || ...
            (hv == 17 && dealerHand(1).value == 2) || ...
            (value_between(13, 17, hv) && value_between(7, 11, dealerHand(1).value)) || ...
            (value_between(13, 16, hv) && value_between(2, 3, dealerHand(1).value)) || ...
            (value_between(2, 3, hv) && dealerHand(1).value == 4)
            val = true;
        end
    end

    function val = decideToHit3(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});
        if (value_between(12, 16, hv) && value_between(7, 8, dealerHand(1).value)) || ...
            (value_between(12, 15, hv) && dealerHand(1).value == 9) || ...
            (value_between(12, 14, hv) && value_between(10, 11, dealerHand(1).value)) || ...
            (hv == 12 && value_between(2, 3, dealerHand(1).value)) || ...
            (hv == 10 && value_between(10, 11, dealerHand(1).value)) || ...
            (hv == 9 && dealerHand(1).value == 2) || ...
            (hv == 9 && value_between(9, 11, dealerHand(1).value)) || ...
            (value_between(5, 8, hv))
                val = true;
        end
    end

    function val = decideToDoubleDown1(dealerHand, hand, k)
        val = false;
        if hand{k}(1).value == 5 && value_between(2, 9, dealerHand(1).value)
            val = true;
        end
    end

    function val = decideToDoubleDown2(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});
        if (value_between(15, 18, hv) && value_between(4, 6, dealerHand(1).value)) || ...
            (hv == 18 && dealerHand(1).value == 6) || ...
            value_between(17, 18, hv) && dealerHand(1).value == 3 || ...
            (hv == 18 && dealerHand(1).value == 2) || ...
            (value_between(13, 14, hv) && value_between(5, 6, dealerHand(1).value)) 
                val = true;
        end
    end

    function val = decideToDoubleDown3(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});
        if (hv == 11) || ...
            (hv == 10 && value_between(2, 9, dealerHand(1).value)) || ...
            (hv == 9 && value_between(3, 6, dealerHand(1).value))
                val = true;
        end
    end

    function val = value_between(a, b, value)
        if value >= a && value <= b
            val = true;
            return;
        end
        val = false;
    end

    function val = checkIfPair(cards)    
        if length(cards) == 2 && cards(1).value == cards(2).value
            val = true;
            return;
        end
        val = false;
    end

    function val = checkIfHasAce(cards)
        if length(cards) == 2 && (cards(1).value == 11 || cards(2).value == 11)
            val = true;
            return;
        end
        val = false; 
    end


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
end
