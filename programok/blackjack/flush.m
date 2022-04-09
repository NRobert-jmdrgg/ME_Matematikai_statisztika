function val = flush(hand, dealer_faceup) 
    val = false;
    if (strcmp(hand(1).suit, dealer_faceup.suit)) && (strcmp(hand(2).suit, dealer_faceup.suit))
        val = true;
    end
end

