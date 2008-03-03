function chebfunobj = chebfun(varargin)
% CHEBFUN   Constructor
%
% CHEBFUN(f) constructs a chebfun object for the function f on the
% interval [-1,1].  f can be a string, e.g 'sin(x)', a function handle, e.g
% @(x) x.^2 + 2x +1, or a number.  If f is a data string, i.e, a string of 
% the form '[a1;a2;...;an]', the numbers a1,...,an are used as the function
% values at Chebyshev points. 
%
% CHEBFUN(f,[a b]) specifies an interval [a b] where the function is
% defined.  If f is a data string, the numbers correspond to function
% values at Chebyshev points scaled to [a b].
%
% CHEBFUN(f,np) overrides the adaptive construction process to specify
% the number np of Chebyshev points to construct the chebfun.
% CHEBFUN(f,[a b],np) specifies the interval of definition and the
% number np of Chebyshev points.  These options do not work if f is
% a data string.
% 
% CHEBFUN(f1,f2,...,fm,ends), where ends is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun from the functions f1,...,fm. 
% Each funcion fi can be a string, a function handle or a number, and is 
% defined in the interval [ends(i) ends(i+1)]. 
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
% of a cell array 'funs' containing m funs, a vector 'ends' of length
% m+1 defining the intervals where the funs apply, and a matrix 'imps'
% containing information about possible delta functions at the breakpoints
% between funs.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0



% if ~ispref('chebfun_defaults')
%     addpref('chebfun_defaults','maxn',128);
%     addpref('chebfun_defaults','splitting',1);
%     addpref('chebfun_defaults','degree_mode',1);
% end

if nargin == 0, 
    chebfunobj = struct('funs',{{}},'ends',[],'imps',[],'nfuns',[]);
    chebfunobj = class(chebfunobj,'chebfun');
    return;
end

if isa(varargin{1},'chebfun')
    if length(varargin)==1
        chebfunobj = varargin{1};
        return;
    else
        error('Unrecognized input sequence.');
    end
end   
% chebfun main components: ------------------------------------------------
funs = {};
ends = [];
% ------------------------------------------------------------------------
% flags : ----------------------------------------------------------------
ninps = nargin; % # of inputs
n = []; % # of Chebyshev points for each fun specified in input (or -1)
nflag = 0;       % = 1 if the # of Chebyshev points for each fun is known
funsflag = 0;    % = 1 when the field "funs" is ready
endsflag = 0;    % = 1 when the field "ends" is ready
% ------------------------------------------------------------------------
% main loading process : -------------------------------------------------
propertyArgIn = varargin;
while ninps > 0,
    prop = propertyArgIn{1};
    propertyArgIn = propertyArgIn(2:end);
    ninps = ninps - 1;
    if ~funsflag && isa(prop,'fun')
        % a fun: append it to the funs array.
        funs{end+1} = prop;
    elseif ~funsflag && (isa(prop,'function_handle') || isa(prop,'char') || ...
            (isa(prop,'double') && length(prop) == 1))
        % a function handle, or a string (function or data) and a number:
        % append it to the funs array.
        funs{end+1} = prop;
    elseif iscell(prop)
        % a cell array: it must contain all the funs.
        funs = prop; funsflag = 1;            
    elseif isa(prop,'double') && length(prop) > 1
        % a vector: it could be ends or n;  we can assume that all the
        % required funs have been loaded
        funsflag = 1;
        if ~endsflag && (length(prop) == length(funs) + 1)
            % loading ends
            ends = prop; endsflag = 1;
        elseif endsflag && (length(prop) == length(funs))  &&~nflag
            % loading n
            n = prop; nflag = 1;
        else
            error('There was an error loading the vector');
        end
    elseif funsflag && (isa(prop,'double') && length(prop) == 1)
        % a scalar, and the funs have already been loaded: it is n.
        n = prop; nflag = 1;
    else 
        error('Unrecognized input sequence');
    end
    
    if ninps == 1,      % only one input remaining ... 
         funsflag = 1; % ... it cannot belong to funs
    end  
end % end of while
%-------------------------------------------------------------------------
if ~endsflag 
    if (length(funs) == 1)
        ends = [-1,1];
    else
        error('Define the intervals where each function is defined')
    end
end
%-------------------------------------------------------------------------
if nflag
    % # of Chebyshev points are prescribed by the user.
    if length(n)~=length(funs)
        error('Prescribe the number of Chebyshev points for all the funs.');
    end
    for i = 1:length(funs)
        if isa(funs{i},'char'), funs{i} = inline(funs{i}); end
        f = funs{i};
        x=cheb(n(i));
        a = ends(i); b = ends(i+1);
        x = (1-x)*a/2 + (x+1)*b/2;
        ffuns{i} = fun;
        ffuns{i} = set(ffuns{i},'val',f(x),'n',n(i)); %<- problem with constants
    end
else
    ffuns = {};
    for i = length(funs):-1:1
        f = funs{i};
        if isa(f,'double')
            f = {fun(f)}; % make a fun from a constant
        elseif isa(f,'char')
            data = str2num(f);
            if ~isempty(data) 
                f = {fun(f,length(data)-1)}; % <- data is stored in reverse
            else
                f = inline(f);
                f = vectorwrap(f,ends(i:i+1));
                [f,e] = auto(f,ends(i:i+1));
                ends = [ends(1:i-1) e ends(i+2:end)];
            end
        elseif isa(f,'function_handle')|| isa(f,'inline')
           f = vectorwrap(f,ends(i:i+1));
           [f,e] = auto(f,ends(i:i+1));
            ends = [ends(1:i-1) e ends(i+2:end)];
        elseif isa(f,'fun')
            f = {f};
        end
        ffuns = [f;ffuns];
    end
end
chebfunobj.funs = ffuns;
chebfunobj.ends = ends;
chebfunobj.imps = zeros(size(ends));
chebfunobj.nfuns = length(ffuns);

superiorto('function_handle');
chebfunobj = class(chebfunobj,'chebfun');

end


function g = vectorwrap(f,x)

% Try to determine whether f is vectorized. If not, wrap it in a loop.

g = f;
try
  f(x);
catch
  g = @loopwrapper;
end

  function v = loopwrapper(x)
    v = zeros(size(x));
    for j = 1:numel(v)
      v(j) = f(x(j));
    end
  end
end
