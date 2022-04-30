function [number_of_wins, number_of_draws, number_of_losses, money_per_round, round_counter, sidebet_stats] = BlackjackBestStrategy(number_of_decks, money, bet_amount, number_of_rounds, end_cond, print_cond, sb_name, sb_amount)
    %
    %   Plotolashoz szukseges valtozok
    %
    number_of_wins = 0;
    number_of_draws = 0;
    number_of_losses = 0;
    win_streak = 0;
    lose_streak = 0;

    sidebet_stats = zeros(5, 1);

    if number_of_rounds(end) == '%'
        percent = str2double(number_of_rounds(1:end - 1))
        if percent < 100
            fprintf('100%%-nal nagyobbank kell lennie\n');
            return;
        end
        percent = (percent / 100);
    end

    auto_bet = false;
    minimum_bet = bet_amount;
    if strcmp(bet_amount, 'auto')
        minimum_bet = 5;
        auto_bet = true;
        bet_amount = decideBetAmount(money, win_streak, lose_streak);
    end

    max_number_of_hands = 4;
    % kiiratashoz eltarojuk a kezdopenzt
    starting_money = money;
    % clear screen matlab konzolra
    clc;

    global deck;

    %
    %   Addig megy a jatek, ameddig el nem telik megadott kor vagy a jatekos mar nem tud a minimum fogadast fizetni.
    %
    round_counter = 0;
    sidebet = getSideBet(sb_name, sb_amount, bet_amount);

    % disp(sidebet)
    % (money >= (minimum_bet + sidebet.sidebet_amount))
    while eval(end_cond) && (money >= (minimum_bet + sidebet.sidebet_amount))
        fprintf('kartyak szama: %d\n', length(deck));
        money_per_round(round_counter + 1) = money;
        updateStreaks();
        if auto_bet
            bet_amount = decideBetAmount(money, win_streak, lose_streak);
        end
        % jatekos kezei
        number_of_hands = 1;
        % dealer kap 2 kártyát
        dealerHand = getCardsFromDeck(2, number_of_decks);
        % játékosnak max 4 'keze' lehet.
        hand = {[], [], [], []};
        % játékos kap 2 kártyát
        hand{1} = getCardsFromDeck(2, number_of_decks);
        %
        %   donteshez szukseges boolean valtozok
        %
        canDoubleDown = true;
        canBlackjack = true;
        canHit = true;

        fprintf('Round %d\n', round_counter + 1);
        % a jatekos minden kezere van fogadas (4 emelu tomb inicializalva 0-akkal)
        bet = zeros(4, 1);
        % belepo fogadas
        bet(1) = bet_amount;
        fprintf('money: %d, bet_amount: %d side_bet: %s sidebetAmount %d sidebet szorzo %d\n', money, bet_amount, sidebet.name, sidebet.sidebet_amount, sidebet.multiplier);
        money = money - bet_amount - sidebet.sidebet_amount;

        if sidebet.func_ptr(hand{1}, dealerHand(1))
            fprintf('Nyert a sidebet\n');
            money = money + sidebet.sidebet_amount * sidebet.multiplier;
            sidebet_stats(sidebet.num) = sidebet_stats(sidebet.num) + 1;
        else
            fprintf('vesztett a sidebet\n');
        end

        % uj sidebet
        sidebet = getSideBet(sb_name, sb_amount, bet_amount);

        % debug kiiratas
        fprintf('dealer keze:\n');
        for i = 1:2
            disp(dealerHand(i));
        end

        %
        %   Vegigmegyunk az osszes kezen es megnezzuk, hogy hit / split / double vagy stand legyen a lepes
        %
        k = 1;
        while k <= number_of_hands
            % megnezzuk hogy a játékos k-adik keze páros pl 3-3 lapok
            if checkIfPair(hand{k})
                % split esetén új fogadás és kéz lesz.
                if decideToSplit1(dealerHand, hand, k) && (number_of_hands < max_number_of_hands && money >= bet(k))
                    fprintf('jatekos split\n');
                    bet(number_of_hands + 1) = bet_amount;
                    % bet az uj kezre
                    money = money - bet_amount;
                    % Ha aszt splitelunk akkor nincs hit es blackjack
                    if hand{k}(1).value == 11 && hand{k}(2).value == 11
                        canHit = false;
                        canBlackjack = false;
                    end

                    % jatekos 2 uj lapot
                    hand{number_of_hands + 1}(1).value = hand{k}(2).value;
                    hand{number_of_hands + 1}(1).name = hand{k}(2).name;
                    hand{number_of_hands + 1}(1).suit = hand{k}(2).suit;
                    hand{number_of_hands + 1}(2) = getCardsFromDeck(1, number_of_decks);
                    hand{k}(2) = getCardsFromDeck(1, number_of_decks);
                    number_of_hands = number_of_hands + 1;
                    % ujrakezdjuk a kezek vizsgalatat
                    k = 1;
                    % csak akkor double down ha meg nem hitelt a jatekos es van elegendo penze es ugy dont, hogy duplaz
                elseif canDoubleDown && (money >= bet(k)) && decideToDoubleDown1(dealerHand, hand, k)
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    % vizsgaljuk a kovetkezo kezet
                    k = k + 1;
                    % csak akkor hitelhetunk, ha nem spliteltunk asz part.
                elseif canHit && decideToHit1(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    % hit utan nincs double down
                    canDoubleDown = false;
                else
                    k = k + 1;
                end
            elseif checkIfHasAce(hand{k})
                if canDoubleDown && decideToDoubleDown2(dealerHand, hand, k) && (money >= bet(k))
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    k = k + 1;
                elseif canHit && decideToHit2(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    canDoubleDown = false;
                else
                    k = k + 1;
                end
            else
                if canDoubleDown && (money >= bet(k)) && decideToDoubleDown3(dealerHand, hand, k)
                    fprintf('jatekos %d kez double down\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    bet(k) = bet(k) + bet_amount;
                    money = money - bet_amount;
                    k = k + 1;
                elseif canHit && decideToHit3(dealerHand, hand, k)
                    fprintf('jatekos %d kez hit\n', k);
                    hand{k}(end + 1) = getCardsFromDeck(1, number_of_decks);
                    canDoubleDown = false;
                else
                    k = k + 1;
                end
            end
        end
        % debug kiiratas
        fprintf('jatekos keze:\n');
        for k = 1:number_of_hands
            fprintf('%d. kez\n', k);
            for i = 1:length(hand{k})
                disp(hand{k}(i));
            end
        end

        % megszamojuk a besokalt kezeket
        busted_hand_count = 0;

        for i = 1:number_of_hands
            hv = getHandValue(hand{i});
            if hv > 21
                fprintf('jatekos %d. keze besokalt\n', i);
                bet(i) = 0;
                fprintf('jatekos vesztett\n');
                busted_hand_count = busted_hand_count + 1;
                number_of_losses = number_of_losses + 1;
            end
        end

        % ha a jatekosnak van olyan keze, ami nincs besokalva
        if busted_hand_count ~= number_of_hands
            % dealer huz addig amig 17 nem lesz  a keze
            while getHandValue(dealerHand) < 17
                dealerHand(end + 1) = getCardsFromDeck(1, number_of_decks);
            end

            fprintf('dealer keze 17 felett:\n');

            for i = 1:length(dealerHand)
                disp(dealerHand(i));
            end

            dhv = getHandValue(dealerHand);
            fprintf('Dealer kezenek erteke: %d\n', dhv);

            %%% debug kiiras
            for i = 1:number_of_hands
                fprintf('hand %d Bet: %d\n', i, bet(i));
            end

            % ha a dealer keze besokalt, akkor a jatekos nyer
            if dhv > 21
                fprintf('dealer besokalt %d\n', dhv);
                for i = 1:number_of_hands
                    money = money + round(bet(i) * 2);
                end
                number_of_wins = number_of_wins + (number_of_hands - busted_hand_count);
            else
                for i = 1:number_of_hands
                    hv = getHandValue(hand{i});
                    % debut kiiras
                    fprintf('jatekos %d. kezenek erteke: %d\n', i, hv);
                    % ha mindketto blackjack de a jatekosnak tobb lapja van, akkor a dealer jer
                    if hv == 21 && dhv == 21 && length(hand{k}) > 2
                        fprintf('dealer blackjack\n');
                        fprintf('jatekos vesztett\n');
                        number_of_losses = number_of_losses + 1;
                    elseif hv == dhv
                        fprintf('dontetlen\n');
                        money = money + round(bet(i));
                        number_of_draws = number_of_draws + 1;
                    elseif canBlackjack && hv == 21 && length(hand{i}) == 2
                        fprintf('jatekos blackjack\n');
                        fprintf('jatekos nyert\n');
                        money = money + round(bet(i) * 2.5);
                        number_of_wins = number_of_wins + 1;
                    elseif hv > dhv
                        fprintf('jatekos nyert\n');
                        money = money + round(bet(i) * 2);
                        number_of_wins = number_of_wins + 1;
                    elseif hv < dhv
                        if dhv == 21
                            fprintf('dealer blackjack\n');
                        end
                        fprintf('jatekos vesztett\n');
                        number_of_losses = number_of_losses + 1;
                    end
                end
            end
        else
            fprintf('a jatekos osszes keze besokalt\n');
        end

        fprintf('maradek penz: %d\n', money);
        round_counter = round_counter + 1;
    end

    if eval(print_cond)
        fprintf('elfogyott a penz\n');
    else
        fprintf('vege\n');
        fprintf('Profit: %d\n', money - starting_money);
    end

    % nested functions

    %
    % 1-es dontesi fuggvenyek, akkor vannak hivva, ha a kez egy par
    %
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

        if (value_between(2, 7, hand{k}(1).value) && value_between(8, 11, dealerHand(1).value)) || ...
                (value_between(4, 6, hand{k}(1).value) && dealerHand(1).value == 7) || ...
                (value_between(4, 5, hand{k}(1).value) && value_between(2, 4, dealerHand(1).value)) || ...
                (hand{k}(1).value == 5 && value_between(5, 6, dealerHand(1).value))
            val = true;
        end
    end

    function val = decideToDoubleDown1(dealerHand, hand, k)
        val = false;

        if hand{k}(1).value == 5 && value_between(2, 9, dealerHand(1).value)
            val = true;
        end
    end

    %
    %   2-es fuggvenyek akkor vannak hivva, ha a kez aszt tartalmaz
    %
    function val = decideToHit2(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});

        if (value_between(13, 17, hv)) || ...
                (hv == 18 && value_between(9, 11, dealerHand(1).value))
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

    %
    % 3 as dontes egyeb esetben
    %
    function val = decideToHit3(dealerHand, hand, k)
        val = false;
        hv = getHandValue(hand{k});

        if (value_between(5, 11, hv)) || ...
                (hv == 12 && value_between(2, 3, dealerHand(1).value)) || ...
                (value_between(12, 16, hv) && value_between(7, 11, dealerHand(1).value))
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

    function updateStreaks()
        if length(money_per_round) >= 2
            if money_per_round( end - 1) > money
            if win_streak > 0
                win_streak = 0;
            end
            lose_streak = lose_streak + 1;
        elseif money_per_round(end - 1) < money
            if lose_streak > 0
                lose_streak = 0;
            end
            win_streak = win_streak + 1;
        end
    end
end
end
