% rpc1 Bernoulli's lemniscates

t = chebfun('t', [0 2*pi]);
for a = 1 : 10, 
    x = a * cos(t) ./ ( 1 + sin(t) .^ 2); 
    y = a * sin(t) .* cos(t) ./ (1 + sin(t) .^ 2);
    plot(x,y,'LineWidth',2), hold on
end
hold off