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
    if ~exist('strategy') || isempty(strategy)
        strategy = 'best'
    end

    switch strategy
    case 'best'
        BlackjackBestStrategy(number_of_decks, money, bet_amount, number_of_rounds);
    end
end
