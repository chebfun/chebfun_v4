function varargout = solvebvp(N,rhs)
% SOLVEBVP is the general chebop command for solving linear or nonlinear
% ODE BVPs (boundary-value problems).  At the moment, it offers no features
% beyond what can be obtained through the "nonlinear backslash" command.
% Later, it will have more options (in analogy to the relationship between
% \ and LINSOLVE in standard Matlab).
%
% Example:
% [d,x,N] = domain(-1,1);
% N.op = @(u) diff(u,2) + sin(u);
% N.lbc = 0;
% N.rbc = 1;
% u = solvebvp(N,0);    % equivalent to u = N\0
% norm(N(u))            % test that ODE is satisfied
%
% There are several preferences that users can adjust to control
% the solution method used by SOLVEBVP (or \).  See CHEBOPPREF.
% In particular, one can specify
%
% cheboppref('damped','off')   % pure Newton iteration
% cheboppref('damped','on')    % damped Newton iteration (the default)
%
% One can also control display options during the solution process.
% See CHEBOPPREF.

% Developed by Toby Driscoll and Asgeir Birkisson, 2009.

if strcmp(cheboppref('damped'),'off')
    [varargout{1} varargout{2}] = solve(N,rhs);
else
    [varargout{1} varargout{2}] = solve_newton_damped(N,rhs);
end

end
