function j = jump(u,x,c)
% JUMP   Compute the jump in a chebfun over a breakpoint.
% J = JUMP(F,X) is simply a wrapper for F(X,'right')-U(F,'left')
% See also chebfun/feval.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin < 3, c = 0; end

j = feval(u,x,'right') - feval(u,x,'left') - c;

