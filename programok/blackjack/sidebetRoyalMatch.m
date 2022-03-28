function val = sidebetRoyalMatch(hand)
    val = false;
    if hand{1}(1).suit == hand{1}(2).suit || ...
        val = true;
    end
end