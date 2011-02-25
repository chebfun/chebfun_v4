function fout = diag(L)
% DIAG The diagonal of linear chebop
% F = DIAG(L) returns the chebfun that lies on the diagonal line of the
% linear operator L. Note, this is not defined if L is not linear, and not
% well defined if it is, but is not a diagonal operator. In that case, 
% DIAG(L) issues and error and in the latter issues a warning.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

d = domain(L);
cheb1 = chebfun(1,d);
L = linop(L);

% Check whether L is truly a diagonal linop.
if norm(full(feval(L,10))-diag(diag(feval(L,10)))) == 0
    fout = L*cheb1;
else
    fout = L*cheb1;
    warning('LINOP:diag',['Taking the diagonal of a nondiagonal ' ...
    'linop is not well defined.']);
end
end