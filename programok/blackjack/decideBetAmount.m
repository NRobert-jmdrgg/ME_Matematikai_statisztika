function bet_amount = decideBetAmount(money, win_streak, lose_streak)
    bet_amount = ceil(money * 0.25);
    if value_between(1, 4, lose_streak)
        bet_amount = ceil(money * (0.25 - (0.05 * lose_streak)));
    elseif lose_streak > 4
        bet_amount = ceil(money * 0.03);
    end
    
    if value_between(1, 14, win_streak)
        bet_amount = ceil(money * (0.25 + (0.05 * win_streak)));
    elseif win_streak > 14
        bet_amount = money;
    end
end