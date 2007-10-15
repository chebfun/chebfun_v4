% rpc7 Diocles' cissoid
t = chebfun('t');

x = 2*t.^2./(1+t.^2);
y = 2*t.^3./(1+t.^2);

plot(x,y,'LineWidth',2)