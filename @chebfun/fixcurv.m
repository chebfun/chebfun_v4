function [x,y] = fixcurv(k)

theta = cumsum(k);
fcos = compose(@cos,theta);
fsin = compose(@sin,theta);
x = cumsum(fcos);
y = cumsum(fsin);
