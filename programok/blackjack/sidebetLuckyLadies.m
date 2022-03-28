function val = sidebetLuckyLadies(hand)
    val = false;
    if getHandValue(hand{1}) == 20
        val = true;
    end
end