function varargout = mldivide(BVP,b)
% \  Solve a nonlinear boundary value problem
%
% U = A\F solves the linear system A*U=F, where U and F are chebfuns and A
% is a nonlinear operator. The BVP is solved using Newton iteration, which
% depends upon the chebfun system ability to calculate derivatives using
% Automatic Differentiation.
%
% EXAMPLE
%   % Newton's method for u'+cos(u)=x, u(0)=1.
%   [d,x,N] = domain(0,1);
%   N.op = @(u) diff(u) + cos(u);
%   N.lbc = 1;
%   u = N\x;
%   plot(u)
%
% See also chebop/mldivide, solvebvp and nonlinoppref (sets options in the
% solution process).

% See http://www.maths.ox.ac.uk/chebfun/ for chebfun information.
%
% Copyright 2002-2009 by The Chebfun Team. 

% This function calls solvebvp for the BVP and the RHS of \.
[varargout{1} varargout{2}] = solvebvp(BVP,b);

end