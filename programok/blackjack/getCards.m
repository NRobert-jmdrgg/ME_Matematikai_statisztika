function cards = getCards()
    i = 1;
    k = 1;
    cards = zeros(52);
    
    while k <= 52
        cards(k) = i;
        cards(k + 1) = i;
        cards(k + 2) = i;
        cards(k + 3) = i;
        k = k + 4;
        i = i + 1;
    end
end