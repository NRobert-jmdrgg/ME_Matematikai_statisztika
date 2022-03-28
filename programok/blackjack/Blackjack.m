function Blackjack(number_of_decks, money, bet_amount, number_of_rounds, strategy)
    % input check
    if ~exist('number_of_decks') || isempty(number_of_decks)
        number_of_decks = 1;
    elseif number_of_decks > 8
        fprintf('Tul sok kartya\n');
        return;
    elseif number_of_decks < 1
        fprintf('Tul keves kartya\n');
        return;
    end
    if ~exist('money') || isempty(money)
        money = 10000;
    elseif money < 1
        fprintf('Tul keves penz\n');
        return;
    end
    if ~exist('bet_amount') || isempty(bet_amount)
        bet_amount = round(money * 0.1);
    elseif bet_amount < 1
        fprintf('Tul keves fogadas\n');
        return;
    elseif bet_amount > money
        fprintf('Tul sok fogadas\n');
        return;
    end
    if ~exist('number_of_rounds') || isempty(number_of_rounds)
        number_of_rounds = 100000;
    elseif number_of_rounds < 1
        fprintf('Tul keves kor\n');
        return;
    end

    % pakli kártya előkészítése
    deck = getCards(number_of_decks);
    % pakli keverése
    deck = deck(randperm(length(deck)));
    max_number_of_hands = 4;
    
    clc;

    %%%% Test
    r = 1;
    while r <= number_of_rounds && money >= bet_amount
        fprintf('kartyak szama: %d\n', length(deck));
        number_of_hands = 1;
        % dealer kap 2 kártyát
        dealerHand = getCardsFromDeck(2);
        % játékosnak max 4 'keze' lehet.
        hand = {[], [], [], []};
        % játékos kap 2 kártyát
        hand{1} = getCardsFromDeck(2);
        fprintf('Round %d\n', r);
        % fogadás tömb
        bet(1) = bet_amount;
        fprintf('money: %d, bet_amount: %d\n', money, bet_amount);
        money = money - bet_amount;
        fprintf('dealer keze:\n');
        for i = 1 : 2
            disp(dealerHand(i));
        end

        fprintf('jatekos keze:\n');
        % endturn = false;
        % while ~endturn

        % end
        k = 1;
        while k <= number_of_hands
            % megnezzuk hogy a játékos k-adik keze páros pl 3-3 lapok
            if checkIfPair(hand{k})
                % split esetén új fogadás és kéz lesz.
                if decideToSplit1(dealerHand, hand, k) && (number_of_hands < max_number_of_hands && money >= (sum(bet) + bet(k)))
                    fprintf('jatekos split\n');
                    bet(number_of_hands + 1) = bet_amount;
                    money = money - bet_amount;
                    hand{number_of_hands + 1}(1).value = hand{k}(2).value;
                    hand{number_of_hands + 1}(1).suit = hand{k}(2).suit;
                    hand{number_of_hands + 1}(2) = getCardsFromDeck(1);
                    hand{k}(2) = getCardsFromDeck(1);
                    number_of_hands = number_of_hands + 1;
                    k = 1;
                elseif decideToHit1(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                elseif decideToDoubleDown1(dealerHand, hand, k) && (money >= (sum(bet) + bet(k)))
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    k = k + 1;
                else
                    k = k + 1;
                end        
            elseif checkIfHasAce(hand{k})
                if decideToDoubleDown2(dealerHand, hand, k) && (money >= (sum(bet) + bet(k)))
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    k = k + 1;
                elseif decideToHit2(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                else
                    k = k + 1;
                end
            else
                if decideToDoubleDown3(dealerHand, hand, k) && (money >= (sum(bet) + bet(k)))
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    k = k + 1;
                elseif decideToHit3(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(length(hand{k}) + 1) = getCardsFromDeck(1);
                else
                    k = k + 1;
                end
            end
        end

        for k = 1 : number_of_hands
            fprintf('%d. kez\n', k);
            for i = 1 : length(hand{k})
                disp(hand{k}(i));
            end
        end

        while getHandValue(dealerHand) < 17
            dealerHand(length(dealerHand) + 1) = getCardsFromDeck(1);
        end

        fprintf('dealer keze 17 felett:\n');
        for i = 1 : length(dealerHand)
            disp(dealerHand(i));
        end

        dhv = getHandValue(dealerHand);
        fprintf('Dealer kezenek erteke: %d\n', dhv);

        %%% test
        for i = 1 : number_of_hands
            fprintf('hand %d Bet: %d\n', i, bet(i));
        end

        if dhv > 21
            fprintf('dealer besokalt %d\n', dhv);
            for i = 1 : number_of_hands
                money = money + round(bet(i) * 2);
            end
        else 
            for i = 1 : number_of_hands
                hv = getHandValue(hand{i});
                fprintf('jatekos %d. kezenek erteke: %d\n', i, hv);
                if hv > 21
                    
                    fprintf('jatekos besokalt\n');
                elseif hv == dhv 
                    fprintf('dontetlen\n');
                elseif hv == 21
                    fprintf('jatekos blackjack\n');
                    money = money + round(bet(i) * 2.5);
                elseif hv > dhv
                    fprintf('jatekos nyert\n');
                    money = money + round(bet(i) * 2);
                elseif hv < dhv
                    fprintf('jatekos vesztett\n');
                    
                end
            end
        end

        fprintf('maradek penz: %d\n', money);
        r = r + 1;
    end

    if r < number_of_rounds
        fprintf('elfogyott a penz\n');
    else
        fprintf('vege\n');
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
            (value_between(12, 13, hv) && dealerHand(1).value == 4)
            val = true;
        end
    end

    function val = decideToHit3(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});
        if (value_between(12, 16, hv) && value_between(7, 11, dealerHand(1).value)) || ...
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
            fprintf('Elfogytak a kartyak uj pakli\n');
            deck = getCards(number_of_decks);
            deck = deck(randperm(length(deck)));
        end
        cards = struct('value', 0, 'suit', '');
        for j = 1 : n
            cards(j) = deck(length(deck));
            deck(length(deck)) = [];
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
