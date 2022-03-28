function val = sidebetMatchTheDealer(dealerHand, hand)
    val = false;
    if hand{1}(1) == dealerHand(1) || hand{1}(2) == dealerHand(1)
        val = true;
    end
end