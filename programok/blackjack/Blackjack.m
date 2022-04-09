function Blackjack(number_of_decks, money, bet_amount, number_of_rounds, strategy, sidebet_name, sb_amount)
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
    elseif number_of_rounds(end) == '%'
        percent = str2double(number_of_rounds(1 : end - 1))
        if percent < 100
            fprintf('100%-nal nagyobbank kell lennie');
            return;
        end
        percent = (percent / 100);
    end
    if ~exist('strategy', 'var') || isempty(strategy)
        strategy = 'best';
    end
    if ~exist('sidebet_name', 'var') || isempty(sidebet_name)
        sidebet.name = 'None';
        sidebet.func_ptr = @nop;
        sidebet.multiplier = 0;
        sidebet.sbet_amount = 0;
    elseif exist(sidebet_name, 'file') ~= 0
        sidebet.name = sidebet_name;
        sidebet.func_ptr = str2func(sidebet_name);
        switch sidebet_name
        case 'flush'
            sidebet.multiplier = 5;
        case 'straight'
            sidebet.multiplier = 10;
        case 'threeOfAKind' 
            sidebet.multiplier = 30;
        case 'straightFlush'
            sidebet.multiplier = 40;
        case 'suitedTriple'
            sidebet.multiplier = 100;
        end

        if ~exist('sb_amount', 'var') || isempty(sb_amount)
            sidebet.sidebet_amount = bet_amount;
        elseif sb_amount <= 0
            fprintf('Tul keves sidebet penz\n');
            return;
        elseif sb_amount > money
            fprintf('Tul sok sidebet penz\n');
            return;
        else
            sidebet.sidebet_amount = sb_amount;
        end
    else
        fprintf('Nincs ilyen sidebet\n');
        return;
    end
    
    if isnumeric(bet_amount)
        switch strategy
            case 'best'
                if exist('percent', 'var') 
                    BlackjackBestStrategyStopAfterProfits(number_of_decks, money, bet_amount, percent, sidebet);
                else
                    BlackjackBestStrategy(number_of_decks, money, bet_amount, number_of_rounds, sidebet);
                end
        end
    else
        switch strategy
            case 'best' 
                if exist('percent', 'var')  %auto
                    BlackjackBestStrategyAutoBetStopAfterProfits(number_of_decks, money, percent, sidebet);
                else
                    BlackjackBestStrategyAutoBet(number_of_decks, money, number_of_rounds, sidebet);
                end
        end
    end
end
