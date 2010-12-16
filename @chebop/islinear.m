function islin = islinear(N)
% ISLINEAR Checks whether a chebop is linear.
% ISLINEAR(N) returns 1 if N is a linear operator, 0 otherwise.

% Store the function we let the chebop operate on
u = chebfun('x',N.dom);

% Boundary conditions part
ab = N.dom.ends;
a = ab(1); b = ab(end);

% Left BC
if ~isempty(N.lbc)
    if ~iscell(N.lbc), lbc = {N.lbc};   % wrap singleton in cell
    else lbc = N.lbc;
    end
    for j = 1:length(lbc)
        gu = lbc{j}(u);
        [Dguu nonConst] = diff(gu,u);
        if any(nonConst)
            islin = 0;
            return
        else
            linBC.left(j) = struct('op',Dguu,'val',gu(a,j));
        end
    end
else
    linBC.left = struct([]);
end

% Right BC
if ~isempty(N.rbc)
    if ~iscell(N.rbc), rbc = {N.rbc};   % wrap singleton in cell
    else rbc = N.rbc;
    end
    for j = 1:length(rbc)
        gu = rbc{j}(u);
        [Dguu nonConst] = diff(gu,u);
        if any(nonConst)
            islin = 0;
            return
        else
            linBC.right(j) = struct('op',diff(gu,u),'val',gu(b,j));
        end
    end
else
    linBC.right = struct([]);
end

% Functional part
try
    Nu = N.op(u);
    [JNuu nonConst] = diff(Nu,u);
catch ME
    rethrow(ME);
end

if nonConst
     islin = 0;
     return
end

% If we get here, we must have a linear operator
islin = 1;