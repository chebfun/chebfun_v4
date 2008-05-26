% % rpc10 compute the parametrization of a curve with 
% squarewave curvature 

t = chebfun(@(t) t,[-5*pi 5*pi]);
kappa = sign(sin(t));
[x,y] = fixcurv(kappa);
plot(x,y,'LineWidth',2)
axis tight
disp('Press ENTER to continue')
pause
kappa2 = curvature({x;y});
plot(kappa2);