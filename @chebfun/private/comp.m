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
%    See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

% Note: this function does not deal with deltas! It will delete them!
% Only the first row of imps is updated. 

%-------------------------------------------------------
% Deal with quasimatrices.
Fout = F1;

% One chebfun
if nargin < 3
    for k = 1:min(size(F1))
        Fout(k) = compcol(F1(k), op);
    end
% Two chebfuns    
else        
    if size(F1) ~= size(F2)
        error('CHEBFUN:comp:QMdimensions','Quasimatrix dimensions must agree')
    end
    for k = 1:min(size(F1))
        Fout(k) = compcol(F1(k), op, F2(k));
    end
end

%-------------------------------------------------------
% Deal with a single chebfun (op needs only ONE input)
function f1 = compcol(f1, op, f2)

% For an empty chebfun, there is nothing to do.
if isempty(f1), return, end

% Initialise (and overlap if there are two chebfuns)
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

% Loop through the funs
for k = 1:f1.nfuns
    % Update vscale (horizontal scale remains the same)
    f1.funs(k).scl.v = vscl;
    % Attaempt to generate funs using the fun constructor.
    if nargin == 2
        [newfun ish] = compfun(f1.funs(k),op);
    else
        [newfun ish] = compfun(f1.funs(k),op,f2.funs(k));
    end
    if ish || (~ish && ~chebfunpref('splitting')) 
    % If we're happy, or not allowed to split, this will do.
       if ~ish
            warning('CHEBFUN:comp:resolv', ...
            ['Composition with function ', func2str(op), ' not resolved using ',  ...
            int2str(newfun.n), ' pts. Have you tried ''splitting on''?']);
       end
       ffuns = [ffuns newfun];                  % Store this fun
       ends = [ends f1.ends(k+1)];              % Store the ends
       if nargin == 2                           % Store the imps
           imps = [imps op(f1.imps(1,k+1))];
       else
           imps = [imps op(f1.imps(1,k+1),f2.imps(1,k+1))]; 
       end
       vscl = max(vscl,newfun.scl.v);           % Get new estimate for vscale
    elseif chebfunpref('splitting')
    % If sad and splitting is 'on', get a chebfun for that subinterval.
       if all(isfinite(f1.ends(k:k+1)))
       % Since we know we must split at least once: 
           endsk = [f1.ends(k) mean(f1.ends(k:k+1)) f1.ends(k+1)]; 
       % We'll try to remove this below with merge.    
       else
       % For unbounded domains, we let the constructor figure out where to split.    
           endsk = f1.ends(k:k+1);
       end
       if nargin == 2
           newf = chebfun(@(x) op(feval(f1,x)), endsk);
       else
           newf = chebfun(@(x) op(feval(f1,x),feval(f2,x)), endsk);
       end
       if all(isfinite(f1.ends(k:k+1)))
       % We forced a breakpoint above, try to remove it.   
           indx = find(newf.ends == endsk(2),1);
           newf = merge(newf,indx);
       end
       ffuns = [ffuns newf.funs];               % Store new funs
       ends = [ends newf.ends(2:end)];          % Store new ends
       imps = [imps newf.imps(1,2:end)];        % Store new imps
       vscl = max(vscl,newfun.scl.v);           % Get new estimate for vscale
    end
         
end

% Update scale of funs:
f1.nfuns = length(ends)-1;
for k = 1:f1.nfuns
    ffuns(k).scl.v = vscl;
end
% Put the funs back into a chebfun.
f1.funs = ffuns; f1.ends = ends; f1.imps = imps; f1.scl = vscl;