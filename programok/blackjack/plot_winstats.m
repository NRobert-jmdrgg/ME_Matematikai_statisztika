function plot_winstats(number_of_wins, number_of_draws, number_of_losses)

    figure;
    winstats = [number_of_wins; number_of_draws; number_of_losses];
    winstatlabels = {'WIN', 'DRAW', 'LOSS'};
    b = bar(winstats, 'FaceColor', 'Green');
    text(1:length(winstats), winstats, num2str(winstats), 'vert', 'bottom', 'horiz', 'center', 'FontSize', 14);
    set(gca, 'xticklabel', winstatlabels, 'FontSize', 18);
    set(get(gca, 'Title'), 'String', native2unicode('nyerési arány'));
    set(gca, 'YTick', [])

end
