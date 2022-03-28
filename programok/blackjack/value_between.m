function val = value_between(a, b, value)
    if value >= a && value <= b
        val = true;
        return;
    end
    val = false;
end