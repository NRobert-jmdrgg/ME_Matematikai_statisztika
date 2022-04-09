function val = straightFlush(hand, dealer_faceup)
    cards = hand;
    cards(end + 1) = dealer_faceup;
    T = struct2table(cards);
    sortedT = sortrows(T, 'value');
    cards = table2struct(sortedT);

    if length(unique({cards.suit})) ~= 1
        val = false;
        return;
    end;
    for i = 2 : length(cards)
        if (cards(i).value - cards(i - 1).value) ~= 1
            val = false;
            return;
        end
    end
    val = true;
end