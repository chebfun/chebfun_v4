% Plot a green light with chebfun to celebrate it going open source

t = chebfun('t');
r = exp(1i*pi*t)+2.5i;
y = exp(1i*pi*t);
g = exp(1i*pi*t)-2.5i;
b = 1.1*[t-3.5i ; 3.5i*t-1 ; -t+3.5i ; -3.5i*t+1];
figure
fill(real(b),imag(b),'k'); hold on
plot(r,'r',y,'y',g,'g');
fill(real(g),imag(g),'g'); hold off
axis equal
