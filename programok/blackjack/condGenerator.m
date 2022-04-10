function [end_cond, print_cond] = condGenerator(number_of_rounds)
    if isnumeric(number_of_rounds)
        end_cond = 'round_counter < number_of_rounds';
        print_cond  = 'round_counter < number_of_rounds';
    else
        end_cond = 'money < starting_money * percent';
        print_cond  = 'money <= (bet_amount + sidebet.sidebet_amount)';
    end
end