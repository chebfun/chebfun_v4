function Nout = uminus(N)
% -  Negate a nonlinop.
 
Nout = nonlinop(N.dom, @(u) -N.op(u));

end