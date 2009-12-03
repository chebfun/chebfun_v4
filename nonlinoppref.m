function varargout = nonlinoppref(varargin)
% NONLINOPPREF settings for nonlinear backslash
%
% More details and more options to follow.
%
% Options to be added include: Update tolerance, Residual tolerance,
% (absolute or relative tolerance). Fixed stepsize. Automatic finding of
% stepsize. Different search direction.
%
% Asgeir Birkisson, 2009

persistent prefs

% Initialize
if isempty(prefs)  % first call, default values
    prefs.plotting = 'off';
    prefs.restol= 1e-10;
    prefs.deltol = 1e-10;
    prefs.damped = 'off';
    prefs.maxiter = Inf;
end

% Return nonlinoppref or assign values 
if nargin==0
    varargout = { prefs };
elseif nargin==1
    varargout = { prefs.(varargin{1}) };
else
    prop = lower(varargin{1});
    newVal = varargin{2};
    switch prop
        case 'restol'
            prefs.(prop) = newVal;
        case 'deltol'
            prefs.(prop) = newVal;
        case 'tol'
            prefs.restol = newVal;
            prefs.deltol = newVal;
        case 'plotting'
            % Need to improve plotting options
            prefs.(prop) = newVal;
        case 'damped'
            prefs.(prop) = newVal;
        case 'maxiter'
            prefs.(prop) = newVal;     
        otherwise
            error(['Nonlinoppref: Unknown property ' prop '.']);
    end
    
end