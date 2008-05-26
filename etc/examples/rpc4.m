% rpc4 Cornu spiral: curve obtained when the Fresnel
%      integrals are used as  parametrization components.
%      Compare cover of Higham & Higham MATLAB book.
%      Ricardo Pachon 12/06.

t = chebfun(@(t) t,[-10 10]);
x = cumsum(cos(t.^2/2));
y = cumsum(sin(t.^2/2));
plot(x,y), axis equal
disp('type <Enter> to see the dance')
pause,
hold off
comet(x,y)