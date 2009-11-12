function pass = blowupscl

% Tests scale invariance for functions with blowups
% Rodrigo Platte Nov 2009

s = 2^20;

a = -2;
b = -1.01;

% Horizontal 
fh = @(x) 1.*(1-x).^b.*(pi+x).^a;
f = chebfun(fh,'exps',{a b},[-pi 1]);
f1 = chebfun(@(x) fh(x/s), [-s*pi s],'exps',{a b});

xx = linspace(-pi+eps(pi),1-eps,1000);
norm((f(xx)-fh(xx))./fh(xx),inf)
norm(f.vals - f1.vals,inf)

pass(1) = all(f.vals == f1.vals);

% Vertical
fh = @(x) sin(x)./(1-x).^b./(1+x).^a;
f = chebfun(fh,'exps',{a b});
f1 = chebfun(@(x) s*fh(x),'exps',{a b});
pass(2) = all(f.vals == f1.vals/s);


