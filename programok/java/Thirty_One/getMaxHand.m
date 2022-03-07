function maxCards = getMaxHand(T)
    [m, i] = max(table2array(T(:, 5)));
    maxCards = table2cell(T(i, :));
end