function sidebet = getRandomSidebet(sb_amount, bet_amount)
    rs = randi([1, 6]); 

    s_names__ = {'flush', 'straight', 'threeOfAKind', 'straightFlush', 'suitedTriple', 'None'};
    s_func_ptrs__ = {@flush, @straight, @threeOfAKind, @straightFlush, @suitedTriple, @nop};
    s_multipliers__ = [5, 10, 30, 40, 100, 0];
    if strcmp(sb_amount, 'auto')
        s_sidebet_amount__  = ceil(bet_amount / 2);
    else
        s_sidebet_amount__  = sb_amount;
    end

    sidebet.name = s_names__{rs};
    sidebet.func_ptr = s_func_ptrs__{rs};
    sidebet.multiplier = s_multipliers__(rs);
    sidebet.sidebet_amount = s_sidebet_amount__;
end