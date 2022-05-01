function final_outcome = update_outcome(final_outcome, hands, dealerHand, hand_ends)
    dhv = getHandValue(dealerHand)
    for i = 1:length(hands)
        hvs(i) = getHandValue(hands{i});
    end

    hvs

    if hand_ends
        d_col = 3;
    else
        d_col = 2;
    end

    for i = 1:length(any(hvs))
        if hvs(i) < 17
            final_outcome(1, 1) = final_outcome(1, 1) + 1;
        elseif hvs(i) == 17
            final_outcome(2, 1) = final_outcome(2, 1) + 1;
        elseif hvs(i) == 18
            final_outcome(3, 1) = final_outcome(3, 1) + 1;
        elseif hvs(i) == 19
            final_outcome(4, 1) = final_outcome(4, 1) + 1;
        elseif hvs(i) == 20
            final_outcome(5, 1) = final_outcome(5, 1) + 1;
        elseif hvs(i) == 21
            final_outcome(6, 1) = final_outcome(6, 1) + 1;
        else
            final_outcome(7, 1) = final_outcome(7, 1) + 1;
        end
    end

    if dhv < 17
        final_outcome(1, d_col) = final_outcome(1, d_col) + 1;
    elseif dhv == 17
        final_outcome(2, d_col) = final_outcome(2, d_col) + 1;
    elseif dhv == 18
        final_outcome(3, d_col) = final_outcome(3, d_col) + 1;
    elseif dhv == 19
        final_outcome(4, d_col) = final_outcome(4, d_col) + 1;
    elseif dhv == 20
        final_outcome(5, d_col) = final_outcome(5, d_col) + 1;
    elseif dhv == 21
        final_outcome(6, d_col) = final_outcome(6, d_col) + 1;
    else
        final_outcome(7, d_col) = final_outcome(7, d_col) + 1;
    end
end
