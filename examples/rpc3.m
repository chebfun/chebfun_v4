% rpc3 Dimonds. Notice that these curves couldn't be implemented using the
% usual fun system due to the absolute value.

t = chebfun('t', [0 2*pi]);
for a  = 1 : 10
    x = abs(cos(t)) .^ ( a - 1 ) .* cos(t);
    y = abs(sin(t)) .^ ( a - 1 ) .* sin(t);
    plot(x,y,'LineWidth',2), hold on
end
hold off
axis equal