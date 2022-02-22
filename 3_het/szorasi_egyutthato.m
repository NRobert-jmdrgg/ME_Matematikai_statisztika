function egyutthato = szorasi_egyutthato(x)
    n = length(x);
    s = 0;
    x_ = mean(x);
    for i = 1 : n
        s = s + (x(i) - x_);
    end

    s = s / n;
    egyutthato = s / x_;
end