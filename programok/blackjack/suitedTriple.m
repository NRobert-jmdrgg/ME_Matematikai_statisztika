function val = suitedTriple(hand, dealer_faceup)
    val = false;
    if isequaln(hand(1), hand(2), dealer_faceup)
        val = true;
    end
end