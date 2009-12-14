function varargout = cheboppref(varargin)
% CHEBOPPREF Settings for chebops.  (Highly subject to change in the future!)
%
% By itself, CHEBOPPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBOPPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBOPPREF('factory') restore all preferences to their factory defined
% values.
%
% CHEBOPPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL. S = CHEBOPPREF(PREFNAME,PREFVAL) stores the current state of
% cheboppref in the structure S before PREFNAME is changed.
%
% CHEBOP PREFERENCES (case sensitive)
%
% maxdegree - maximum matrix size used in linear chebop calculations
%
% storage - controls whether matrix LU factorizations are saved to speed
%        up later calculations.
%
% maxstorage - max memory devoted to storage
%
% display - controls information displayed during nonlinear solution
%    'none' (default)
%    'iter' - plot iterates and updates during solution process
%    'final' - plot solution at end
%
% plotting - controls whether the most current solution and update of the
%     iteratation are plotted
%     'off' - no plotting (default)
%     'on'  - plots and pauses for the default time (0.5 s)
%     time  - current iteration and update are plotted for a value of time,
%           i.e. cheboppref('plotting',1) shows the plots for 1 s.
%     'pause' - pauses the run of the program after plots are shown to wait
%               for user action.
%
% restol - tolerance of norm of residual relative to norm of solution
%
% deltol - tolerance of norm of update relative to norm of solution
%
%          (Convergence occurs if either of the above two norms are below tolerance)
%
% damped - controls method of nonlinear solution
%     'off'  - pure Newton iteration (perhaps less robust, more interesting!)
%     'on'   - damped Newton iteration (perhaps more robust; default)
%
% maxiter - maximum number of iterations allowed in nonlinear iteration
%
% maxstagnation - number of steps with little improvement used to define
%     stagnation in damped Newton iteration
%
% See also chebfunpref.

% Copyright 2008-2009 by Toby Driscoll and Asgeir Birkisson.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

persistent prefs

if isempty(prefs)  % first call, default values
    prefs = initPrefs();
end

if nargout == 1
    varargout = {prefs};
end

% Probably should use some nicer error catching...
if nargin==0  % return structure
    varargout = { prefs };
elseif nargin==1  % return value
    if isstruct(varargin{1})
        % Assign prefs from structure input
        prefs = varargin{1};
        return
    end
    if strcmp(varargin{1},'factory')
        prefs = initPrefs;
    else
        varargout = { prefs.(varargin{1}) };
    end
else  % set value
    prop = lower(varargin{1});
    newVal = varargin{2};
    switch prop
        case 'tol'
            prefs.restol = newVal;
            prefs.deltol = newVal;
        case 'plotting'
            if strcmp(newVal,'on')
                prefs.plotting = 0.5;
            else
                prefs.plotting = newVal;
            end
        otherwise
            prefs.(prop) = newVal;
            
    end
end


function prefs = initPrefs()
prefs.maxdegree = 1024;
prefs.storage = true;
prefs.maxstorage = 50e6;
prefs.display = 'none';
prefs.plotting = 'off';
prefs.restol= 1e-10;
prefs.deltol = 1e-10;
prefs.damped = 'on';
prefs.maxiter = 25;
prefs.maxstagnation = 5;

