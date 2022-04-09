function val = threeOfAKind(hand, dealer_faceup)
    cards = hand;
    cards(end + 1) = dealer_faceup;
    x = {cards.name};
    c = categorical(x);
    y = countcats(c);

    if y(y == 3) 
        val = true;
        return;
    end
    val = false;
end