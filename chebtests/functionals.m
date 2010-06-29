function pass = functionals

%  Toby Driscoll

%  Last commit: $Author: hale $: $Rev: 1030 $:
%  $Date$:


[d,x] = domain(-1,2);
f = cos(x)./(1+x.^2);
S = sum(d);
A = [S; -2*S];
pass(1) = norm( sum(f)*[1;-2] - A*f ) < 100*chebfunpref('eps');

end