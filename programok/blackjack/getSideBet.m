function sidebet = getSideBet(sb_name, sb_amount, bet_amount)
    if strcmp(sb_name, 'None')
        sidebet.num = 0; 
        sidebet.name = 'None';
        sidebet.func_ptr = @nop;
        sidebet.multiplier = 0;
        sidebet.sidebet_amount = 0;
    elseif strcmp(sb_name, 'random')
        sidebet = getRandomSidebet(sb_amount, bet_amount);
    else
        sidebet.name = sb_name;
        sidebet.func_ptr = str2func(sb_name);
        switch sb_name
        case 'flush'
            sidebet.num = 1;
            sidebet.multiplier = 5;
        case 'straight'
            sidebet.num = 2;
            sidebet.multiplier = 10;
        case 'threeOfAKind' 
            sidebet.num = 3;
            sidebet.multiplier = 30;
        case 'straightFlush'
            sidebet.num = 4;
            sidebet.multiplier = 40;
        case 'suitedTriple'
            sidebet.num = 5;
            sidebet.multiplier = 100;
        end

        if strcmp(sb_amount, 'auto')
            sidebet.sidebet_amount  = ceil(bet_amount / 2);
        else
            sidebet.sidebet_amount  = sb_amount;
        end
    end
end