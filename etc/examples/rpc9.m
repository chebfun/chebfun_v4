% % rpc9 compute the parametrization of a curve with 
% curvature = t*(sin(t))^2

t = chebfun(@(t) t, [-20 20]);
kappa = t.*(sin(t)).^2;
[x,y] = fixcurv(kappa);
plot(x,y,'LineWidth',2)
axis tight