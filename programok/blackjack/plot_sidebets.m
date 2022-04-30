function plot_sidebets(sidebet_stats, round_counter)
    sidebet_stats
    if any(sidebet_stats)
        labels = {'flush', 'straight', 'three of a kind', 'straight flush', 'suited triple'};
        figure;
        bar(sidebet_stats);
        set(gcf, 'units', 'normalized');
        set(gcf, 'Position', [0, 0, 0.7, 0.4]);
        set(gca, 'xticklabel', labels, 'FontSize', 18);
    end
end
