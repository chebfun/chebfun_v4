function varargout = cheboppref(varargin)
% CHEBOPPREF Settings for chebops.
%
% By itself, CHEBOPPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBOPPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBOPPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL.
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

% Probably should use some nicer error catching...
if nargin==0  % return structure
    varargout = { prefs };
elseif nargin==1  % return value
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
        otherwise
            prefs.(prop) = newVal;
            
    end
end
end
function prefs = initPrefs()
    prefs.maxdegree = 1024;
    prefs.storage = true;
    prefs.maxstorage = 50e6;
    prefs.plotting = 'off';
    prefs.restol= 1e-10;
    prefs.deltol = 1e-10;
    prefs.damped = 'off';
    prefs.maxiter = Inf;
    prefs.maxstag = 3;
end
