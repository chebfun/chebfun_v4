function varargout = solvebvp(N,rhs)
% SOLVEBVP alternative to nonlinear backslash. This function will offer the
% possibility of more output arguments and the passing in of options (cf.
% odeset).
%
% MLDVIVIDE now calls solve or solve_newton_damped directly.

if strcmp(cheboppref('damped'),'off')
    [varargout{1} varargout{2}] = solve(N,rhs);
else
    [varargout{1} varargout{2}] = solve_newton_damped(N,rhs);
end

end
