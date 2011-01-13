function [L linBC isLin] = linearise(N,u,flag)
%LINEARISE   Linearise a chebop.
% [L linBC isLin] = LINEARISE(N,u) Linearises the chebop N about the
% chebfun u.
%
% LINEARISE(N,U,1) is simply a islinear check, so we kick out if
% nonlinearity is detected (and return garbage in L and linBC). (This is
% also used by chebop/linop which returns an error when the chebop is
% nonlinear).

% For expm, we need to be able to linearize around u = 0, so we offer the
% option of linearizing around a certain function here (similar to diff),
% the difference is that we check for linearity in this method as well.
if nargin == 1 || isempty(u)
    if isempty(N.dom)
        error('CHEBFUN:chebop:linop:emptydomain', ...
            'Cannot linearise a chebop defined on an empty domain.'); 
    end
%   Create a chebfun to let the operator operate on. Using the findguess
%   method ensures that the guess is of the right (quasimatrix) dimension.
    u = findguess(N);
end

% Initialise
if nargin < 3, flag = 0; end
isLin = 1;
linBC = [];

% Boundary conditions part
ab = N.dom.ends;
a = ab(1); b = ab(end);

% Left BC
if ~isempty(N.lbc)
    if ~iscell(N.lbc), lbc = {N.lbc};   % wrap singleton in cell
    else lbc = N.lbc;
    end
    l = 1;
    for j = 1:length(lbc)
        guj = lbc{j}(u);
        for k = 1:numel(guj);
            [Dgujk nonConst] = diff(guj(:,k),u);
            if any(nonConst),  isLin = 0;   end
            if ~isLin && flag == 1, return, end
            linBC.left(l) = struct('op',Dgujk,'val',guj(a,k));
            l = l+1;
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
    l = 1;
    for j = 1:length(rbc)
        guj = rbc{j}(u);
        for k = 1:numel(guj);
            [Dgujk nonConst] = diff(guj(:,k),u);
            if any(nonConst),  isLin = 0;   end
            if ~isLin && flag, return,      end
            linBC.right(l) = struct('op',Dgujk,'val',guj(b,k));
            l = l+1;
        end
    end
else
    linBC.right = struct([]);
end

% Functional part
try
    Nu = N.op(u);
    [L nonConst] = diff(Nu,u);
catch ME
    rethrow(ME);
end
if any(any(nonConst)),  isLin = 0;   end
