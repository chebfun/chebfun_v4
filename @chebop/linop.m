function L = linop(N,u)
%LINOP Converts a chebop N to a linop L if N is a linear operator

% For expm, we need to be able to linearize around u = 0, so we offer the
% option of linearizing around a certain function here (similar to diff),
% the difference is that we check for linearity in this method as well.
if nargin == 1
    if isempty(N.dom)
        error('CHEBFUN:chebop:linop:emptydomain', ...
            'Cannot linearise a chebop defined on an empty domain.'); 
    end
    u = chebfun('x',N.dom);
end

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
            error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
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
            error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
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
    error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
end

% Assign BCs to the linop
L = JNuu & linBC;
