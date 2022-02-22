function y = empirikus_szorasnegyzet(x)
    n = length(x);
    x_ = mean(x);
    y = 0;
    for i = 1 : n
        y = y + (x(i) - x_)^2;
    end

    y = y / n;
end