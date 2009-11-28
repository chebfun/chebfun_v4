function pass = ad_vs_diff_1
% A test that compares derivatives obtained via AD to derivatives obtained
% with the normal diff of the chebfun system.

[d,x] = domain(0.1,0.9);
cheb1 = chebfun(1,d);
norms = zeros(24,1);

% Inverse trigonometric and hyperbolic functions
norms(1) = norm(diag(diff(acos(x),x))-diff(acos(x)));
norms(2) = norm(diff(acosh(x),x)*cheb1-diff(acosh(x)));

norms(3) = norm(diff(acot(x),x)*cheb1-diff(acot(x)));
norms(4) = norm(diff(acoth(x),x)*cheb1-diff(acoth(x)));

norms(5) = norm(diff(acsc(x),x)*cheb1-diff(acsc(x)));
norms(6) = norm(diff(acsch(x),x)*cheb1-diff(acsch(x)));

norms(7) = norm(diff(asec(x),x)*cheb1-diff(asec(x)));
norms(8) = norm(diff(asech(x),x)*cheb1-diff(asech(x)));

norms(9) = norm(diff(asin(x),x)*cheb1-diff(asin(x)));
norms(10) = norm(diff(asinh(x),x)*cheb1-diff(asinh(x)));

norms(11) = norm(diff(atan(x),x)*cheb1-diff(atan(x)));
norms(12) = norm(diff(atanh(x),x)*cheb1-diff(atanh(x)));

% Trigonometric and hyperbolic functions

norms(13) = norm(diag(diff(cos(x),x))-diff(cos(x)));
norms(14) = norm(diff(cosh(x),x)*cheb1-diff(cosh(x)));

norms(15) = norm(diff(cot(x),x)*cheb1-diff(cot(x)));
norms(16) = norm(diff(coth(x),x)*cheb1-diff(coth(x)));

norms(17) = norm(diff(csc(x),x)*cheb1-diff(csc(x)));
norms(18) = norm(diff(csch(x),x)*cheb1-diff(csch(x)));

norms(19) = norm(diff(sec(x),x)*cheb1-diff(sec(x)));
norms(20) = norm(diff(sech(x),x)*cheb1-diff(sech(x)));

norms(21) = norm(diff(sin(x),x)*cheb1-diff(sin(x)));
norms(22) = norm(diff(sinh(x),x)*cheb1-diff(sinh(x)));

norms(23) = norm(diff(tan(x),x)*cheb1-diff(tan(x)));
norms(24) = norm(diff(tanh(x),x)*cheb1-diff(tanh(x)));


pass = all(norms < chebfunpref('eps')*1e4);