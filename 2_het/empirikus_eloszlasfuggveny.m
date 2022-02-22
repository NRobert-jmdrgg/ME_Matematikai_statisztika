function empirikus_eloszlasfuggveny(minta)
    sort(minta);

    x = minta(1) - 1 : 0.01 : minta(length(minta));
    
    p = x < minta(1);

    y(p) = 0;

    for i = 2 : length(minta) - 1
        p = (x > minta(i - 1)) & (x <= minta(i));
        y(p) = (i / length(minta));
    end

    p = x > minta(length(minta));

    y(p) = 1;

    plot(x, y)

end