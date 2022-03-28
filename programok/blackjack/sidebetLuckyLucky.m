function val = sidebetLuckyLucky(dealerHand, hand)
    p = value_between(19, 21, getHandValue(dealerHand));
    for i = 1 : length(hand)
        hv(i) = sum(hand{i});
        if value_between(19, 21, hv(i)) && p
            val = true;
            return;
        end
    end
end