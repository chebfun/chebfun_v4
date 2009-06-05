function f = chebfun(varargin)
% CHEBFUN   Constructor for chebfuns.
% CHEBFUN(f) constructs a chebfun object for the function f on the
% interval [-1,1].  f can be a string, e.g 'sin(x)', a function handle, e.g
% @(x) x.^2 + 2x +1, or a number.  If f is a doubles array, [a1;a2;...;an],
% the numbers a1,...,an are used as the function values at Chebyshev 
% points. 
%
% CHEBFUN(f,[a b]) specifies an interval [a b] where the function is
% defined. 
%
% CHEBFUN(f,np) overrides the adaptive construction process to specify
% the number np of Chebyshev points to construct the chebfun.
% CHEBFUN(f,[a b],np) specifies the interval of definition and the
% number np of Chebyshev points. 
% 
% CHEBFUN(f1,f2,...,fm,ends), where ends is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun from the functions f1,...,fm. 
% Each function fi can be a string, a function handle or a doubles array, 
% and is defined in the interval [ends(i) ends(i+1)]. 
%
% CHEBFUN(f1,f2,...,fm,ends,np), where np is a vector of length m, specifies
% the number np(i) of Chebyshev points for the construction of fi.
% 
% CHEBFUN(chebs,ends) construct a piecewise smooth chebfun with m pieces
% from a cell array chebs of size m x 1.  Each entry chebs{i} 
% is a function defined on [ends(i) ends(i+1)] represented by a
% string, a function handle or a number.  CHEBFUN(chebs,ends,np)
% specifies the number np(i) of Chebyshev points for the construction
% of the function in chebs{i}.
%
% CHEBFUN creates an empty fun.
%
% F = CHEBFUN(...) returns an object F of type chebfun.  A chebfun consists
% of a vector of 'funs', a vector 'ends' of length m+1 defining the 
% intervals where the funs apply, and a matrix 'imps' containing information
% about possible delta functions at the breakpoints between funs.
%
% F = CHEBFUN(...,PREFNAME,PREFVAL) returns a chebfun using the preference 
% PREFNAME with value specified by PREFVAL. See chebfunpref for possible
% preferences.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

persistent default_f
if isnumeric(default_f)
    default_f = ctor_ini;
    default_f = class(default_f,'chebfun');
end
f = default_f;

% No arguments -> return empty chebfun
if nargin == 0; return, end

% Chebfun preferences:
if isstruct(varargin{nargin})
    pref = varargin{nargin};
    argin = varargin(1:end-1);
else
    pref = chebfunpref;
    % Find out if call changes preferences
    argin = varargin(1);
    k = 2; j = 2;
    while k <= nargin
        if ischar(varargin{k})
            varargin{k} = lower(varargin{k});
            % Is the argument a preference name?
            if  any(strcmp(fieldnames(pref),varargin{k}))
                % If ON or OFF used -> change to true or false
                value = varargin{k+1};
                if ischar(value)
                    if strcmpi(value,'on')
                        value = true;
                    elseif strcmpi(value,'off')
                        value = false;
                    else
                        error('chebfun:chebfun:prefval', ...
                            'Invalid chebfun preference value')
                    end
                end
                pref.(varargin{k}) = value;
                k = k+2;
            else
                argin{j} = varargin{k};
                j = j+1; k = k+1;
            end
        else
            argin{j} = varargin{k};
            j = j+1; k = k+1;
        end
    end
end

% Get domain
if  length(argin) == 1,
    argin{2} = double(pref.domain);
elseif isa(argin{2},'domain')
    argin{2}=double(argin{2});
end

if ~iscell(argin{1})
    argin = unwrap_arg(argin{:});
end

% Construct chebfun
if  length(argin) == 2,
    f = ctor_2(f,argin{:},pref); % adaptive call
elseif length(argin) == 3,
    f = ctor_3(f,argin{:});      % non-adaptive call
end

end
