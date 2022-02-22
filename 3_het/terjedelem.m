function t = terjedelem(x)
    sort(x);
    t = x(length(x)) - x(1);
end