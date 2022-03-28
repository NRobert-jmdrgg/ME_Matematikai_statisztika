function value = getHandValue(cards)
    value = 0;
    if ~isempty(cards)
        value = sum([cards.value]);
        if value > 21
            for card = cards
                if card.value == 11
                    value = value - 10;
                end
            end 
        end
    end
end