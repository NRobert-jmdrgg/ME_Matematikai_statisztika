function Blackjack(number_of_decks, money, bet_amount, number_of_rounds, strategy, sidebet, sidebet_amount)
    % input check
    if ~exist('number_of_decks', 'var') || isempty(number_of_decks)
        number_of_decks = 1;
    elseif number_of_decks > 8
        fprintf('Tul sok kartya\n');
        return;
    elseif number_of_decks < 1
        fprintf('Tul keves kartya\n');
        return;
    end
    if ~exist('money', 'var') || isempty(money)
        money = 10000;
    elseif money < 1
        fprintf('Tul keves penz\n');
        return;
    end
    if ~exist('bet_amount', 'var') || isempty(bet_amount)
        bet_amount = round(money * 0.1);
    elseif bet_amount < 1
        fprintf('Tul keves fogadas\n');
        return;
    elseif bet_amount > money
        fprintf('Tul sok fogadas\n');
        return;
    end
    if ~exist('number_of_rounds', 'var') || isempty(number_of_rounds)
        number_of_rounds = 100000;
    elseif number_of_rounds < 1
        fprintf('Tul keves kor\n');
        return;
    end
    if ~exist('strategy', 'var') || isempty(strategy)
        strategy = 'best';
    end
    if ~exist('sidebet', 'var') || isempty(sidebet)
        sidebet = '';
    end
    if ~exist('sidebet_amount', 'var') || isempty(sidebet_amount)
        sidebet_amount = 0;
    end

    switch strategy
    case 'best'
        BlackjackBestStrategy(number_of_decks, money, bet_amount, number_of_rounds);
    end
end
