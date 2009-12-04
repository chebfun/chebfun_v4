% Test a few things involving sum applied to
% functions with infinities.   LNT & NH 4 Dec. 2009.

function pass = suminftest

a = 33.4*pi; b = 34.6*pi; c = 33.5*pi; d = 34.5*pi;
f = chebfun('tan(x)',[a c d b],'exps',[0 -1 -1 0]);
pass(1) = isnan(sum(f));

f2 = chebfun('tan(x).^2',[a c d b],'exps',[0 -2 -2 0]);
pass(2) = (sum(f2)==inf);

f3 = chebfun('-tan(x).^4',[a c d b],'exps',[0 -4 -4 0]);
pass(3) = (sum(f3)==-inf);

f4 = chebfun('1+1./x.^2',[1 inf]);
pass(4) = (sum(f4)==inf);
