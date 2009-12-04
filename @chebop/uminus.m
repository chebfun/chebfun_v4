function Nout = uminus(N)
% -  Negate a chebop.
 
Nout = chebop(N.dom, @(u) -N.op(u));

end