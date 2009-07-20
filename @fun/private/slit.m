function  m = slit(par)

a = par(1);
b = par(2);
if length(par) == 2;
    E = 0.01;
else
    E = par(3);
end

% scale to handle arbitrary intervals
scale = @(y) ((b-a)*y+b+a)/2;
scaleder = (b-a)/2;

m.for = @(y) scale(slitmap(y,0,E,0));
m.der = @(y) scaleder*slitmap(y,0,E,1);
m.par = [a b E];
m.name = 'slit';



