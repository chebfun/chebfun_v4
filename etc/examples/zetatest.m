clear
clc

f = chebfun(@(z)zeta(exp(z)+1), [2.5 2.7], 100);

xc = .5+14.13472514*i
zc = log(xc-1)

z = linspace(0,pi/2);
z3 = real(zc)+z*i;
x3 = exp(z3)+1;

figure(3)
semilogy(z,abs(f(z3)-zeta(x3)),'-x')

figure(4)
plot(z,real(x3),'-x')