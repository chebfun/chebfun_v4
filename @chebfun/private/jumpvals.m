function vals = jumpvals(funs,ends,op,sing)
% Updates the values at breakpoints, i.e., the first row of imps.
% If there is a singular point, op is evaluated in order to obtain a 
% value at the breakpoint.

vals = zeros(size(ends));
vals(1) = funs(1).vals(1);
for k = 2:numel(funs)
    if ~sing(k)
        vals(k)  = funs(k).vals(1);
    else
        vals(k)  = op(ends(k));
    end
end
vals(end) = funs(end).vals(end);
