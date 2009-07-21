function Fout = comp(F1, op, F2)
% FOUT = COMP(F1,OP,F2)
% COMP(F1,OP) returns the composition of the chebfun F with OP, i.e.,
%   FOUT = OP(F1).
% COMP(F,OP,F2) returns the composition of OP with chebfuns F and F2 with, 
%   i.e., FOUT = OP(F1,F2).
%
% Examples
%        x = chebfun('x')
%        Fout = comp(x,@sin)
%        Fout = comp(x+1,@power,x+5)
%
%    See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

% Note: this function does not deal with deltas! It will delete them!
% Only the first row of imps is updated. 

%-------------------------------------------------------
% Deal with quasimatrices.
Fout=F1;

% One chebfun
if nargin < 3
    for k = 1:min(size(F1))
        if ~isempty(F1(k))
            Fout(k) = compcol(F1(k), op);
        end
    end
    
% Two chebfuns    
else        
    if size(F1) ~= size(F2)
        error('CHEBFUN:comp:QMdimensions','Quasimatrix dimensions must agree')
    end
    for k = 1:min(size(F1))
        if ~isempty(F1(k))
            Fout(k) = compcol(F1(k), op, F2(k));
        end
    end
end

%-------------------------------------------------------
% Deal with a single chebfun (op needs only ONE input)
function f1 = compcol(f1, op, f2)
    
% Get preferences
if chebfunpref('splitting'), n = chebfunpref('splitdegree')+1;    
else n = chebfunpref('maxdegree')+1; end

ffuns = [];
ends = f1.ends(1);
if nargin == 2
    imps = op(f1.imps(1,1));
    vscl = norm( op(get(f1,'vals')), inf);
else
    [f1,f2] = overlap(f1,f2);
    imps = op(f1.imps(1,1),f2.imps(1,1));
    vscl = norm( op(f1.imps(1,:),f2.imps(1,:)), inf);
end
for k = 1:f1.nfuns
    % update vscale ( horizontal scale remains the same)
    f1.funs(k).scl.v = vscl;
    % Generate funs using the fun constructor.
    if nargin == 2
        newfun = compfun(f1.funs(k),op);
    else
        newfun = compfun(f1.funs(k),op,f2.funs(k));
    end
    if newfun.n < n % Happyness test
       ffuns = [ffuns newfun];
       ends = [ends f1.ends(k+1)];
       if nargin == 2, imps = [imps op(f1.imps(1,k+1))];
       else imps = [imps op(f1.imps(1,k+1),f2.imps(1,k+1))]; end
       vscl = max(vscl,newfun.scl.v);    % Get new estimate for vscale
    else
       % If sad, get a chebfun for that subinterval
       if nargin == 2
           newf = chebfun(@(x) op(feval(f1,x)), f1.ends(k:k+1));
       else
           newf = chebfun(@(x) op(feval(f1,x),feval(f2,x)), f1.ends(k:k+1));
       end       
       ffuns = [ffuns newf.funs];
       ends = [ends newf.ends(2:end)];
       imps = [imps newf.imps(1,2:end)];
       vscl = max(vscl,newfun.scl.v);    % Get new estimate for vscale
    end
end
% Update scale of funs:
f1.nfuns = length(ends)-1;
for k = 1:f1.nfuns
    ffuns(k).scl.v = vscl;
end
f1.funs = ffuns; f1.ends = ends; f1.imps = imps; f1.scl = vscl;