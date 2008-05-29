% breakpoints at  8 - 39 - 94 - 103 - 112
clear, clc
format long, format compact
figure

% basic examples

f = fun('sin(x)');

g = fun('cos(x)');

plot(f,'LineWidth',2);

hold on, plot(g,'r','LineWidth',2);

% let's see the degree of the polynomials
length(f)

length(g)

% product of the two functions
h = f.*g;

plot(h,'k','LineWidth',2);

length(h) % the degree is not going to explote

% a more sophisticated example (by LNT)

x = fun('x');
f = sin(pi*x);
s = f;

for j = 1:10, 
    f = (3/4)*(1-2*f.^4); 
    s = s + f; 
end

hold off, plot(s,'LineWidth',2)

% Let's compute the roots

r = introots(s-5)

hold on, plot(r,s(r),'r*','MarkerSize',14)

% and the global maximum and minimum

[mx,sx] = max(s);
[mn,sn] = min(s);

plot(sx,mx,'*r', 'MarkerSize',14');
plot(sn,mn,'*r', 'MarkerSize',14');

% however, fun has some problems...
clc
f = abs(x);

% that's when chebfun comes in !

x = chebfun('x');

f = abs(x);

hold off, plot(f,'LineWidth',2)

length(f)

% chebfun works on arbitrary intervals

f = chebfun('sin(x)', [0 2*pi]);

hold off, plot(f, 'LineWidth',2)

% some parametrized curves in chebfun
t = chebfun('t', [0 2*pi]);

% 8-shaped curve
x = sin(t);
y = sin(t).*cos(t);
plot(x,y)
plot(curvature(x,y),'LineWidth',2)

% (show curvature function)
hold off;

% Bernoulli's lemniscates

for a = 1 : 10, 
    x = a * cos(t) ./ ( 1 + sin(t) .^ 2); 
    y = a * sin(t) .* cos(t) ./ (1 + sin(t) .^ 2);
    plot(x,y), hold on
end
hold off

% cardioids

for a = 1 : 10
    x= 2 * a * cos(t) .* (1 + cos(t));
    y = 2 * a * sin(t) .* (1 + cos(t));
    plot(x,y), hold on
end
hold off

% dimonds

for a  = 1 : 10
    x = abs(cos(t)) .^ ( a - 1 ) .* cos(t);
    y = abs(sin(t)) .^ ( a - 1 ) .* sin(t);
    plot(x,y), hold on
end
hold off

% and finally, some clothoids

t = chebfun('t',[-10 10]);

x = cumsum(sin(t.^2/2));    
y = cumsum(cos(t.^2/2));    

plot(x,y)

x = cumsum(sin(t.^3/3));    
y = cumsum(cos(t.^3/3));    
plot(x,y)

plot(curvature(x,y),'LineWidth',2)