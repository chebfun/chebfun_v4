function f = chebfun(varargin)
% CHEBFUN   Constructor for chebfuns.
% CHEBFUN(F) constructs a chebfun object for the function F on the
% interval [-1,1]. F can be a string, e.g 'sin(x)', a function handle, e.g
% @(x) x.^2 + 2*x +1, or a vector of numbers. In the first two cases, F
% should in most cases be "vectorized" in the sense that it may be evaluated 
% at a column vector of points x(:) and return an output of size length(x(:)).
% If F is a doubles array, [A1;A2;...;An], the numbers A1,...,An are used 
% as the function values at n Chebyshev points.
%
% CHEBFUN(F,[A B]) specifies an interval [A B] where the function is
% defined. A and/or B may be infinite.
%
% CHEBFUN(F,NP) overrides the adaptive construction process to specify
% the number np of Chebyshev points to construct the chebfun.
% CHEBFUN(F,[A B],NP) specifies the interval of definition and the
% number np of Chebyshev points.
%
% CHEBFUN(F,'map',{MAPNAME,MAPPARS}) allows the use of mapped Chebyshev
% expansions. See help chebfun/maps for more information.
%
% CHEBFUN(F,'exps',{EXP1 EXP2}) allows the definition of singularities
% in the function F at the end points of the interval. 
% See help chebfun/blowup for more information.
%
% CHEBFUN(F1,F2,...,Fm,ENDS), where ends is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun from the functions F1,...,Fm.
% Each function Fi can be a string, a function handle or a doubles array,
% and is defined in the interval [ENDS(i) ENDS(i+1)].
%
% CHEBFUN(F1,F2,...,Fm,ENDS,NP), where NP is a vector of length M, specifies
% the number NP(i) of Chebyshev points for the construction of fi. If NP(i)
% is zero the length of the representation will be determined automatically.
%
% CHEBFUN(CHEBS,ENDS) construct a piecewise smooth chebfun with m pieces
% from a cell array chebs of size m x 1.  Each entry CHEBS{i}
% is a function defined on [ENDS(i) ENDS(i+1)] represented by a
% string, a function handle or a number.  CHEBFUN(CHEBS,ENDS,NP)
% specifies the number NP(i) of Chebyshev points for the construction
% of the function in CHEBS{i}.
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
% CHEBFUN(F,'vectorize') prevents the warning message from being displayed
% when F does not appear to be a vectorized input.
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

sings = []; % Default

% Chebfun preferences:
if isstruct(varargin{nargin}) && ~strcmpi(varargin{nargin-1},'map')
    pref = varargin{nargin};
    if ~isfield(pref,'vecwarn'), pref.vecwarn = 1; end
    argin = varargin(1:end-1);
else
    pref = chebfunpref;
    pref.vecwarn = 1;
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
                        % Factory values from chebfunpref
                    elseif strcmpi(value,'factory')
                        value = chebfunpref(varargin{k},'factory');
                    else
                        error('chebfun:chebfun:prefval', ...
                            'Invalid chebfun preference value')
                    end
                end
                pref.(varargin{k}) = value;
                k = k+2;
            elseif strcmpi('map',varargin{k})
                pref.map =  varargin{k+1};
                k = k+2;
            elseif strcmpi('exps',varargin{k})
                pref.exps = varargin{k+1};
                k = k+2;
            elseif strcmpi('vectorize',varargin{k}) || strcmp('vectorise',varargin{k})
                pref.vecwarn = 0;
                k = k+1;  
            elseif strcmpi('degree',varargin{k})
                pref.n = varargin{k+1};
                k = k+2;
            elseif strcmpi('singmap',varargin{k})
                sings = varargin{k+1};
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

if ~isempty(sings)
    if isfield(pref,'map'),
        warning('CHEBFUN:chebfun:singmap','Map is being overridden by singmap');
    end
    pref.map = {'sing',sings};
end

% Get domain
if  length(argin) == 1,
    argin{2} = double(pref.domain);
elseif isa(argin{2},'domain')
    argin{2} = double(argin{2});
end

if ~iscell(argin{1})
    argin = unwrap_arg(argin{:});
end

if isfield(pref,'n')
    argin = [argin {pref.n}];
end

% Construct chebfun
if  length(argin) == 2,
    f = ctor_adapt(f,argin{:},pref);        % adaptive call
elseif length(argin) == 3,
    f = ctor_nonadapt(f,argin{:},pref);     % non-adaptive call
end

% Prune repeated endpoints and assign values to the imps matrix
if f.nfuns > 1 && any(diff(f.ends) == 0)
    k = 1;
    while k < length(f.ends)
        if diff(f.ends(k:k+1)) == 0
            f.ends(k+1) = [];
            f.imps(k+1) = [];
            f.nfuns = f.nfuns - 1;
            f.imps(1,k) = f.funs(k).vals(1);
            f.funs(k) = [];
        else
            k = k+1;
        end
    end
end

end

function f = ctor_ini() % Default fields for a chebfun
% The following fields should always be allocated automatically with the function set.
f = struct([]);
f(1).funs = [];
f(1).nfuns = 0;
f(1).scl = 0;
% The following fields can be manipulated manually.
f(1).ends = [];
f(1).imps = [];
f(1).trans = false;
f(1).jacobian = anon('@(u) []','',[]);
f(1).ID = []; % ID gets assigned in ctor_adapt and ctor_nonadapt, so leave empty here
end
