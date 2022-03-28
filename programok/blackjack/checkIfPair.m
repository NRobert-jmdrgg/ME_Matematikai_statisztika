function val = checkIfPair(cards)    
    if length(cards) == 2 && cards(1).value == cards(2).value
        val = true;
        return;
    end
    val = false;
end