function  m = slit(par)

a = par(1);
b = par(2);
if length(par) == 2;
    W = 0.01i;
else
    W = par(3);
end

% scale to handle arbitrary intervals
scale = @(y) ((b-a)*y+b+a)/2;
scaleder = (b-a)/2;


% m.for = @(y) scale(slitmap(y,real(W),imag(W),0));
% m.der = @(y) scaleder*slitmap(y,real(W),imag(W),1);
[m.for m.der] = slitmap(D+1i*E,[a b]);
m.par = [a b W(:).'];
m.name = 'slit';



