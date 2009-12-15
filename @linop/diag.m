function fout = diag(L)
% DIAG The diagonal of linops
%
% F = DIAG(L) returns the chebfun that lies on the diagonal line of the
% linear operator L. Note that this is not well defined if L is not a
% diagonal operator, in that case, diag(L) issues a warning.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by the Chebfun Team.

%  Last commit: $Author$: $Rev$:
%  $Date$:

d = domain(L);
cheb1 = chebfun(1,d);

% Check whether L is truly a diagonal linop.
if norm(full(feval(L,10))-diag(diag(feval(L,10)))) == 0
    fout = L*cheb1;
else
    fout = L*cheb1;
    warning('LINOP:diag',['Taking the diagonal of a nondiagonal ' ...
    'linop is not well defined.']);
end
end