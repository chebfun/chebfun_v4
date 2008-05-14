function C = uminus(A)
% -  Negate a chebop.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = chebop( -A.varmat, @(u) -feval(A.oper,u), A.fundomain, A.difforder );

end