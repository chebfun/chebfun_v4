% rpc2 Cardioids

t = chebfun('t', [0 2*pi]);
for a = 1 : 10
    x= 2 * a * cos(t) .* (1 + cos(t));
    y = 2 * a * sin(t) .* (1 + cos(t));
    plot(x,y,'LineWidth',2), hold on
end
hold off
axis equal