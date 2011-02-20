function varargout = solvebvp(N,rhs,varargin)
% SOLVEBVP is the general chebop command for solving linear or nonlinear
% ODE BVPs (boundary-value problems).  At the moment, it offers no features
% beyond what can be obtained through the "backslash" command.
% Later, it will have more options (in analogy to the relationship between
% \ and LINSOLVE in standard Matlab).
%
% Example:
% N = chebop(-1,1);
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

% Do all parsing of varargin here rather than in solve_bvp_routines

% If no options are passed, obtain the the chebop preferences

% Initialize arguments to be passed on later
pref = []; guihandles = []; jac = [];

argCounter = 1;
while argCounter <= nargin-2
    arg = varargin{argCounter};
    if strcmpi(arg,'FJacobian') || strcmpi(arg,'FFrechet')
        Fjacobian = varargin{argCounter+1};
    elseif strcmpi(arg,'options')
        pref = varargin{argCounter+1};
    elseif strcmpi(arg,'guihandles')
        guihandles = varargin{argCounter+1};
    else
        error('Chebop:solvebvp',['Unknown option ' arg '.']);
    end
    argCounter = argCounter + 2;
end

if isempty(pref)
    pref = cheboppref;
end
[varargout{1} varargout{2} varargout{3}] = solve_bvp_routines(N,rhs,pref,guihandles);%varargin{:});

