function x_p = p_tapasztalati_kvantilis(x, p)
    n = length(x);
    A = floor(n * p);
    B = floor(n * p) + 1;
    q = (n * p) - floor(n * p);
    x_p = ( (1 - q) * x(A) ) + ( q * x(B) );
end