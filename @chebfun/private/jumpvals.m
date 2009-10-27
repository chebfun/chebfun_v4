function vals = jumpvals(funs,ends,op)
% Updates the values at breakpoints, i.e., the first row of imps.
% If there is a singular point, op is evaluated in order to obtain a 
% value at the breakpoint.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if isa(op,'chebfun')
    op = @(x) feval(op,x);
end

vals = zeros(size(ends));
vals(1) = funs(1).vals(1);

if funs(1).exps(1) < 0, vals(1) = inf;
elseif funs(1).exps(2), vals(1) = vals(1).*diff(ends(1:2)).^funs(1).exps(2); end

if nargin < 3 || isa(op,'double') || isa(op,'fun')
    for k = 2:numel(funs)
        vals(k)  = funs(k).vals(1);
        
        if funs(k).exps(1) < 0, vals(k) = inf;
        elseif funs(k).exps(2), vals(k) = vals(k).*diff(ends(k:k+1)).^funs(k).exps(2); end

    end
else
    for  k = 2:numel(funs)
        vals(k)  = op(ends(k));
        
        if funs(k).exps(1) < 0, vals(k) = inf;
        elseif funs(k).exps(2), vals(k) = vals(k).*diff(ends(k:k+1)).^funs(k).exps(2); end
    end
end

vals(end) = funs(end).vals(end);

if funs(end).exps(2) < 0, vals(end) = inf;
elseif funs(end).exps(1), vals(end) = vals(end).*diff(ends(end-1:end)).^funs(end).exps(1); end
