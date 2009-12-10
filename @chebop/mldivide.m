function varargout = mldivide(BVP,b)
% \  Solve a nonlinear boundary value problem
%
% U = A\F solves the linear system A*U=F, where U and F are chebfuns and A
% is a nonlinear operator. The BVP is solved using Newton iteration, which
% depends upon the chebfun system ability to calculate derivatives using
% Automatic Differentiation.
%
% [U NR] = A\F the same as above, but now NR is a vector that contains
% information about the norm of the update in each iteration (useful for
% convergance analysis).
%
% EXAMPLE 1
%      Newton's method for u'+cos(u)=x, u(0)=1.
%   [d,x,N] = domain(0,1);
%   N.op = @(u) diff(u) + cos(u);
%   N.lbc = 1;
%   u = N\x;
%   plot(u)
%
% EXAMPLE 2
%      Solve the BVP
%   (u_1)'' - sin(u_2) = 0
%   (u_2)'' + cos(u_1) = 0                BVP(3)
%   u_1(-1) = 1,      (u_2)''(-1) = 0
%   (u_1)''(1) = 0,   u_2(1) = 0
% 
%   [d,x,N] = domain(-1,1);
%   N.op = @(u) [ diff(u(:,1),2) - sin(u(:,2)), diff(u(:,2),2) + cos(u(:,1)) ];
%   N.lbc = {@(u) u(:,1)-1, @(u) diff(u(:,2))};
%   N.rbc = {@(u) u(:,2), @(u) diff(u(:,1))}; 
%   [u nrmduvec] = N\0;
%
% There are several preferences that users can adjust to control
% the solution method used by SOLVEBVP (or \).  See CHEBOPPREF.
% In particular, one can specify
%
% cheboppref('damped','off')   % pure Newton iteration
% cheboppref('damped','on')    % damped Newton iteration (the default)
%
% One can also control display options during the solution process.
% 
% See also chebop/solvebvp and cheboppref (sets options in the
% solution process).

% See http://www.maths.ox.ac.uk/chebfun/ for chebfun information.
%
% Copyright 2002-2009 by The Chebfun Team. 

% This function calls solve or solve_newton_damped for the BVP and the RHS of \.

% Switch on cheboppref.damped
if strcmp(cheboppref('damped'),'off')
    [varargout{1} varargout{2}] = solve(BVP,b);
else
    [varargout{1} varargout{2}] = solve_newton_damped(BVP,b);
end
end