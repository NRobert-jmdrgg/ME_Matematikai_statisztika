function val = checkIfHasAce(cards)
    if length(cards) == 2 && (cards(1).value == 11 || cards(2).value == 11)
        val = true;
        return;
    end
    val = false; 
end