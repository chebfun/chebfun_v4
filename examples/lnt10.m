% lnt10.m  interpolate a random walk in 2d  LNT 12/06

x = chebfun('cumsum(randn(101,1))');
y = chebfun('cumsum(randn(101,1))');
plot(x,y), axis equal

