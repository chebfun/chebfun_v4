function f = chebfun(varargin)
% CHEBFUN   Constructor for chebfuns.
% CHEBFUN(F) constructs a chebfun object for the function F on the interval 
% [-1,1]. F can be a string, e.g 'sin(x)', a function handle, e.g 
% @(x) x.^2 + 2*x +1, or a vector of numbers. For the first two, F should 
% in most cases be "vectorized" in the sense that it may be evaluated at a 
% column vector of points x(:) and return an output of size length(x(:)).
% If F is a doubles array, [A1,A2,...,An], the numbers A1,...,An are used 
% as function values at n Chebyshev points of the 2nd kind, i.e. chebpts(n).
%
% CHEBFUN(F,[A B]) specifies an interval [A B] where the function is
% defined. A and/or B may be infinite.
%
% CHEBFUN(F,NP) overrides the adaptive construction process to specify
% the number NP of Chebyshev points to construct the chebfun. This is
% shorthand for CHEBFUN(F,'length',NP). CHEBFUN(F,[A B],NP) specifies both
% the interval of definition and the number of points. If NP is NaN, the
% default adaptive process is used.
%
% CHEBFUN(F,...,'exps',[EXP1 EXP2]) allows the definition of singularities
% in the function F at end points of the interval. If EXP1 and/or EXP2 is 
% NaN, the constructor will attempt to determine the form of the singularity 
% automatically. See help chebfun/blowup for more information.
%
% CHEBFUN([C1,...,CN],'coeffs') constructs a chebfun corresponding to the
% Chebyshev polynomial P(x) = C1*T_{N-1}(x)+C2*T_{N-2}(x)+...+CN.
%
% CHEBFUN(F1,F2,...,Fm,ENDS), where ENDS is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun for the functions F1,...,Fm.
% Each function Fi can be a string, function handle, or doubles array,
% and is defined in the interval [ENDS(i) ENDS(i+1)].
%
% CHEBFUN(CHEBS,ENDS) constructs a piecewise smooth chebfun with m pieces
% from a cell array chebs of size m x 1.  Each entry CHEBS{i} is a function 
% defined on [ENDS(i) ENDS(i+1)] represented by a string, a function handle 
% or a number.  CHEBFUN(CHEBS,ENDS,NP) specifies the number NP(i) of 
% Chebyshev points for the construction of the function in CHEBS{i}.
%
% G = CHEBFUN(...) returns an object G of type chebfun.  A chebfun consists
% of a vector of 'funs', a vector 'ends' of length m+1 defining the
% intervals where the funs apply, and a matrix 'imps' containing information
% about possible delta functions at the breakpoints between funs.
% CHEBFUN(F,[A B]) specifies an interval [A B] where the function is
% defined. A and/or B may be infinite. Calling CHEBFUN with no inputs 
% creates an empty chebfun.
%
% G = CHEBFUN(...,PREFNAME,PREFVAL) returns a chebfun using the preference
% PREFNAME with value specified by PREFVAL. See chebfunpref for possible
% preferences.
%
% Advanced features:
%
% CHEBFUN(F,'vectorize') wraps F in a for loop. This is useful when F
% cannot be evaluated with a vector input. CHEBFUN(F,'vectorcheck','off') 
% turns off the automatic checking for vector input.
%
% CHEBFUN(F,'scale',SCALE) constructs a chebfun with relative accuracy given 
% by SCALE.
%
% CHEBFUN(F,'trunc',N) returns an N point chebfun constructed by
% constructing the Chebyshev series at degree N-1, rather than by
% interpolation at Chebyshev points. 
%
% CHEBFUN(F,'extrapolate','on') prevents the constructor from evaluating
% the function F at the endpoints of the domain. This may also be achieved
% with CHEBFUN(F,'chebkind','1st','resampling','on') (which uses Chebyshev
% points of the 1st kind during the construction process), although this 
% functionality is still experimental.
%
% CHEBFUN(F,...,'map',{MAPNAME,MAPPARS}) allows the use of mapped Chebyshev
% expansions. See help chebfun/maps for more information.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.
% Copyright 2002-2009 by The Chebfun Team.

persistent default_f
if isnumeric(default_f)
    default_f = ctor_ini;
    default_f = class(default_f,'chebfun');
end
f = default_f;

% No arguments -> return empty chebfun
if nargin == 0; return, end

% Chebfun preferences:
if isstruct(varargin{nargin}) && ~strcmpi(varargin{nargin-1},'map')
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
            
            % If ON or OFF used -> change to true or false
            if k < nargin
                value = varargin{k+1};
                if strcmpi(value,'on')       value = true;
                elseif strcmpi(value,'off')  value = false;
                end
            end
            if strcmpi('factory',varargin{k})
                pref = chebfunpref('factory');
                k = k+1;
            elseif  any(strcmp(fieldnames(pref),varargin{k}))
                % Is the argument a preference name?
                if ischar(value)
                    % Factory values from chebfunpref
                    if strcmpi(value,'factory')
                        value = chebfunpref(varargin{k},'factory');
                    else
                        error('CHEBFUN:chebfun:prefval', ...
                            'Invalid chebfun preference value.')
                    end
                end
                pref.(varargin{k}) = value;
                k = k+2;
            elseif strcmpi('map',varargin{k})
                pref.map =  value;
                k = k+2;             
            elseif strcmpi('exps',varargin{k})
                pref.exps = value;
                k = k+2;
            elseif strncmpi('vectori',varargin{k},7)
                pref.vectorize = 0;
                k = k+1;  
            elseif strncmpi('coeff',varargin{k},4)
                pref.coeffs = 1; 
                if ~isfield(pref,'coeffkind'), pref.coeffkind = 1; end
                k = k+1; 
            elseif strncmpi('trunc',varargin{k},5)
                pref.trunc = value;
                if pref.trunc, pref.splitting = true; end
                k = k+2;                 
            elseif strcmpi('vectorcheck',varargin{k})
                pref.vectorcheck = value;
                k = k+2;                  
            elseif strncmpi('extrap',varargin{k},6)
                pref.extrapolate = value;
                k = k+2;                  
            elseif strcmpi('length',varargin{k}) || strcmpi('n',varargin{k})
                pref.n = value;
                k = k+2;
            elseif strcmpi('scale',varargin{k}) || strcmpi('scl',varargin{k})
                pref.scale = value;
                k = k+2;    
            elseif strcmpi('chebkind',varargin{k}) || strcmpi('kind',varargin{k})
                if      strncmpi(value,'1st',1), value = 1;
                elseif  strncmpi(value,'2nd',1), value = 2; end
                if isfield(pref,'coeffs'), 
                    pref.coeffkind = value;
                    pref.chebkind = 2;
                else
                    pref.chebkind = value;
                end
                k = k+2;                    
            elseif strcmpi('singmap',varargin{k})
                pref.sings = value;
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

% Deal with singmaps
if isfield(pref,'sings')
    if isfield(pref,'map'),
        warning('CHEBFUN:chebfun:singmap','Map is being overridden by singmap.');
    end
    pref.map = {'sing',pref.sings};
    pref = rmfield(pref,'sings');
end

% Get domain
if length(argin) == 1,
    if isa(argin{1},'fun')
        argin{2} = argin{1}.map.par(1:2);
    else
        argin{2} = double(pref.domain);
    end
elseif isa(argin{2},'domain')
    argin{2} = double(argin{2});
end

% Deal with nonadaptiv calls using 'degree'.
if isfield(pref,'n')
    argin = [argin {pref.n}];
    pref = rmfield(pref,'n');
end

% Deal with multiple function inputs.
if ~iscell(argin{1})
    argin = unwrap_arg(argin{:});
end

% Construct chebfun
if  length(argin) == 2,
    f = ctor_adapt(f,argin{:},pref);        % adaptive call
elseif length(argin) == 3,
    f = ctor_nonadapt(f,argin{:},pref);     % non-adaptive call
else
    error('CHEBFUN:chebfun:nargin','Unrecognised input sequence.');
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

% 'Truncate' option
if isfield(pref,'trunc')
    c = chebpoly(f,0,pref.trunc);
    f = chebfun(chebpolyval(c),f.ends([1 end]));
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
