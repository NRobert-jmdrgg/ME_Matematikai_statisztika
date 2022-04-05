function val = sidebetInBet(dealerHand, hand)
    val = false;
    c = sort([hand{1}.value])
    if value_between(c(1), c(2), dealerHand(1))
        val = true;
    end
end