function chebfunobj = chebfun(varargin)
% CHEBFUN   Constructor
% CHEBFUN(f) constructs a chebfun object for the function f on the
% interval [-1,1]. f can be a string, e.g 'sin(x)', a function handle, e.g
% @(x) x.^2 + 2x +1, a number. If f is a data string, i.e, a string of the
% form '[a1;a2;...;an]', the numbers a1,...,an are used as the values of the
% function on Chebyshev points. 
%
% CHEBFUN(f,[a b]) specifies an interval [a b] where the function is
% defined. In case that f is a data string, the numbers correspond to the
% values of the function on Chebyshev points scaled to the interval [a b].
%
% CHEBFUN(f,np) specifies the number np of Chebyshev points to construct the 
% chebfun. CHEBFUN(f,[a b],np) specifies the interval of definition and the
% number of Chebyshev points. Neither of this two options work when f is a
% data string.
% 
% CHEBFUN(f1,f2,...,fm,ends), where ends is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun from the functions f1,...,fm. 
% The funcion fi can be a string, a function handle or a number, and it is 
% defined in the interval [ends(i) ends(i+1)]. 
%
% CHEBFUN(f1,f2,...,fm,ends,np), where n is a vector of length m, specifies
% the number n(i) of Chebyshev points for the construction of fi.
% 
% CHEBFUN(chebs,ends) construct a piecewise smooth chebfun with m pieces
% from a cell array chebs of size m x 1. Each entry chebs{i} in the cell
% array is a function defined on [ends(i) ends(i+1)] represented by a
% string, a function handle or a number. CHEBFUN(chebs,ends,np) specifies
% the number n(i) of Chebyshev points for the construction of the function
% in chebs{i}.
%
% CHEBFUN creates an empty fun.
%
% F = CHEBFUN(...) returns an object F of type chebfun. A chebfun stores
% the function values on Chebyshev points (scaled to the appropriate
% intervals) of the approximating function in the field 'funs', the end
% points where each pice is defined in the field 'ends', and information of
% Dirac impulses in the field 'imps'.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

if nargin == 0, 
    chebfunobj = struct('funs',[],'ends',[],'imps',[]);
    chebfunobj = class(chebfunobj,'chebfun');
    return;
end
    
% chebfun main components: ------------------------------------------------
funs = {};
ends = [];
imps = []; 
% ------------------------------------------------------------------------
% flags : ----------------------------------------------------------------
ninps = nargin; % # of inputs
n = []; % # of Chebyshev points for each fun specified in input (or -1)
nflag = 0;       % = 1 if the # of Chebyshev points for each fun is known
funsflag = 0;    % = 1 when the field "funs" is ready
endsflag = 0;    % = 1 when the field "ends" is ready
impsflag = 0;    % = 1 when the field "imps" is ready
xfuns = 0;

% ------------------------------------------------------------------------
% main loading process : -------------------------------------------------
propertyArgIn = varargin;
while ninps > 0,
    prop = propertyArgIn{1};
    propertyArgIn = propertyArgIn(2:end);
    ninps = ninps - 1;
    if ~funsflag && isa(prop,'fun')
        funs{end+1} = prop;
        xfuns = xfuns + 1;
    elseif ~funsflag && (isa(prop,'function_handle') || isa(prop,'char') || ...
            (isa(prop,'double') && length(prop) == 1))
        funs{end+1} = prop;
    elseif iscell(prop)
        funs = prop; funsflag = 1;
        if not(isempty(prop)) && isa(prop{1},'fun')
            xfuns = length(prop);
        end
    elseif isa(prop,'double') && length(prop) > 1
        % a vector: it could be ends, imps or n; in case we
        % can assume that all the required funs have been loaded.
        funsflag = 1;
        if ~endsflag && (length(prop) == length(funs) + 1)
            % loading ends
            ends = prop; endsflag = 1;
        elseif endsflag && (length(prop) == length(funs))  &&~nflag
            % loading n
            n = prop; nflag = 1;
        elseif endsflag && (size(prop,2) == length(ends))
            imps = prop;
            impsflag = 1;
        elseif (isempty(funs))
            % no funs were loaded; chebfun only has information of ends
            ends = prop; endsflag = 1;
        else
            error('There was an error loading the vector');
        end
    elseif funsflag && (isa(prop,'double') && length(prop) == 1)
        % a scalar, and the funs have already been loaded: it is n.
        if endsflag 
            n = prop; nflag = 1;
        elseif length(funs) == 1
            % only one fun and a scalar: assume ends = [-1,1]
            n = prop; nflag = 1;
            ends = [-1,1]; endsflag = 1;
        else
            error('There was an error loading a scalar');
        end
    else 
        error('Unrecognized input sequence');
    end
    % a safeguard ------------------------------------
    if ninps == 1,      % only one input remaining ... 
         funsflag = 1; % ... it cannot belong to funs
    end   
    % ------------------------------------------------
end % end of while
%-------------------------------------------------------------------------
% infer and fill non-loaded data: ----------------------------------------
if ~endsflag && ((length(funs) == 1) || nflag)
    ends = [-1,1];
elseif ~endsflag && funsflag
    error('Define the intervals where each function is defined')
end
if isempty(n) 
    for i = 1:length(funs)
        if isa(funs{i},'char') && ~isempty(str2num(funs{i}))
            % discrete data; make sure the degree of the polynomial is
            % correct
            n(i) = length(str2double(funs{i}))-1; 
        elseif isa(funs{i},'double')
            n(i) = 0;
        else
            n(i) = -1;
        end
    end
end
if not(impsflag)
    imps = zeros(size(ends));
end
if xfuns>0 && xfuns<length(funs)
    error('All or none of the input arguments should be of type fun');
elseif xfuns==0
    chebfunobj = chebfun;
    % convert each element of "funs" into a fun : -------------------------
    for i = 1:length(funs)
        f =  auto(funs{i},ends(i:i+1),n(i));
        chebfunobj = [chebfunobj;f];
    end
else
    chebfunobj.funs = funs;
    chebfunobj.ends = ends;
    chebfunobj.imps = imps;
    chebfunobj = class(chebfunobj,'chebfun');
end