function val = sidebetPerfectPairs(hand)
    val = false;
    if checkIfPair(hand{1})
        val = true;
    end
end