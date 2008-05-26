function rpc17()
% Comparison of a non-smooth function versus its chebfun PWS version.
% Ricardo Pachon 01/2007

% construct a function with a singularity in its 5th derivative
splitting off
f = chebfun(@F, [-2 2]);
lenf = length(f)
% construct the same function with pws funs
g = chebfun('x.^5','.5*x.^5',[-2 0 2]);
% (... chebfun allows to define a function by its intervals)
leng = length(g)
% plot both chebfun representations of the same function
plot(f,'b.-'); hold on
plot(g,'r.-','markersize',18); hold off

function F = F(x)
% This is a function with a singularity in its 5th derivative
 F = zeros(size(x));
 F(find(x<=0)) = x(find(x<=0)).^5;
 F(find(x>0)) = .5*x(find(x>0)).^5;