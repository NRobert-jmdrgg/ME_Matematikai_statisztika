function plot_money(money_per_round, starting_money, round_counter)
    figure
    xvals = 1:round_counter;
    length(xvals);
    length(money_per_round);
    plot(xvals, money_per_round, 'LineWidth', 3);
    hold on;
    plot(xvals, starting_money, 'LineWidth', 3);
    set(get(gca, 'Title'), 'String', native2unicode('Körönkénti pénz', 'UTF-8'));
    set(get(gca, 'XLabel'), 'String', native2unicode('játszmák száma', 'UTF-8'));
    set(get(gca, 'YLabel'), 'String', native2unicode('pénz', 'UTF-8'));
    set(gca, 'FontSize', 18);
end
