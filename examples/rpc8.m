% rpc8 compute the parametrization of a curve with 
% curvature = t + sin(t). Notice that it is different 
% from the Cornu spiral in rpc4.

t = chebfun(@(t) t, [-12 12]);
kappa =  t+ sin(t);
[x,y] = fixcurv(kappa);
plot(x,y,'LineWidth',2)
axis tight
disp('Press ENTER to continue')
pause
tic
kappa2 = curvature({x;y});
toc
plot(kappa2,'LineWidth',2);
