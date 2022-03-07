function minCards = getMinHand(T)
    [m, i] = min(table2array(T(:, 5)));
    minCards = table2cell(T(i, :));
end