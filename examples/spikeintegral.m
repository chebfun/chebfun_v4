splitting on
tic
x = chebfun('x',[0 1]);
f = sech(10*(x-0.2)).^2 + sech(100*(x-0.4)).^4 + sech(1000*(x-0.6)).^6;
sum(f), toc
plot(f)