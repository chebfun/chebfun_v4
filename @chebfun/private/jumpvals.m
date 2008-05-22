function vals = jumpvals(funs,ends,op,sing)
% Updates the values at breakpoints, i.e., the first row of imps.
% If there is a singular point, op is evaluated in order to obtain a 
% value at the breakpoint.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if nargin<3 || isa(op,'double') || isa(op,'fun')
    op=[]; % op is not needed
    sing = zeros(size(ends)); % Ged vaules at brealpoints from funs not op.
end

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
