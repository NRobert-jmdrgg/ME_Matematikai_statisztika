function my_piecewise
    fplot(@(x) exp(x),[-3 0],'b')
hold on
fplot(@(x) cos(x),[0 3],'b')
hold off
grid on
end