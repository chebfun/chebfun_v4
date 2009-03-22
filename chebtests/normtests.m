function pass = normtests

% Nick Trefethen  22 March 2009
tol = chebfunpref('eps');
x = chebfun('x');
absx = abs(x);
pass1 = (norm(absx,1)==1);

dabsx = diff(abs(x));
pass2 = (norm(dabsx,1)==2);
pass3 = (norm(dabsx,inf)==1);
pass4 = (norm(-dabsx,inf)==1);

ddabsx = diff(dabsx);
pass5 = (norm(ddabsx,1)==2);
pass6 = (norm(-ddabsx,1)==2);
pass7 = (norm(ddabsx,inf)==inf);
pass8 = (norm(-ddabsx,inf)==inf);
pass = pass1 && pass2 && pass3 && pass4 && pass5 && pass6 && pass7 && pass8;
