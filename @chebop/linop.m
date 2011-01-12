function [L isLin] = linop(N,u,flag)
%LINOP Converts a chebop N to a linop L if N is a linear operator

% For expm, we need to be able to linearize around u = 0, so we offer the
% option of linearizing around a certain function here (similar to diff),
% the difference is that we check for linearity in this method as well.
if nargin == 1
    if isempty(N.dom)
        error('CHEBFUN:chebop:linop:emptydomain', ...
            'Cannot linearise a chebop defined on an empty domain.'); 
    end
%   Create a chebfun to let the operator operate on. Using the findguess
%   method ensures that the guess is of the right (quasimatrix) dimension.
    u = findguess(N);
end

if nargin < 3, flag = 0; end
% The flag prevents an error from being displayed when N is not linear, and 
% outputs in L the frechet derivative of the nonlinear N about u.
isLin = 1;

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
            if ~flag
                error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
            else
                isLin = 0;
                N.rbc = []; % There's no point checking the N.rbc.
                break
            end
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

if any(any(nonConst)) || ~isLin
    if ~flag
        error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
    else
        isLin = 0;
        L = JNuu; % Output the DE jacobian about u.
    end
else
    % Assign BCs to the linop
    L = JNuu & linBC;
end

