function Blackjack(number_of_decks, money, bet_amount, number_of_rounds, sb_name, sb_amount)
    feature('DefaultCharacterSet', 'UTF8')
    % input check
    if ~exist('number_of_decks', 'var') || isempty(number_of_decks)
        number_of_decks = 6;
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
    starting_money = money;
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
    elseif isnumeric(number_of_rounds) && number_of_rounds < 1
        fprintf('Tul keves kor\n');
        return;
    end

    if ~exist('sb_name', 'var') || isempty(sb_name)
        sb_name = 'None';
        sb_amount = 0;
    end
    if (~exist('sb_amount', 'var') || isempty(sb_amount)) || strcmp('sb_amount', 'auto')
        if strcmp(bet_amount, 'auto')
            sb_amount = ceil(money * 0.1 * 0.25);
        else
            sb_amount = ceil(bet_amount / 2);
        end
    end

    global deck;
    deck = getCards(number_of_decks);
    deck = deck(randperm(length(deck)));

    [end_cond, print_cond] = condGenerator(number_of_rounds);

    [number_of_wins, number_of_draws, number_of_losses, money_per_round, round_counter, sidebet_stats] = BlackjackBestStrategy(number_of_decks, money, bet_amount, number_of_rounds, end_cond, print_cond, sb_name, sb_amount);

    plot_winstats(number_of_wins, number_of_draws, number_of_losses);
    plot_money(money_per_round, starting_money, round_counter);
    plot_sidebets(sidebet_stats, round_counter);
end
