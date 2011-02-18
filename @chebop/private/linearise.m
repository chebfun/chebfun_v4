function [L linBC isLin affine] = linearise(N,u,flag)
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
    u = findguess(N,0); % Second argument 0 denotes we won't try to fit to BCs.
end

% Initialise
if nargin < 3, flag = 0; end
isLin = 1;
linBC = [];
affine = [];

% Check whether we are working with anonymous functions which accept
% quasimatrices or arguments such as @(u,v). In the former case,
% no special measurements have to be taken, but in the latter, in
% order to allow evaluation, we need to create a cell array with
% entries equal to each column of the quasimatrix representing the
% current solution.
numberOfInputVariables = nargin(N.op);

if numberOfInputVariables > 1 % Load a cell, with the linear function x as the first entry
    uCell = cell(1,numel(u));
    for quasiCounter = 1:numel(u)
        uCell{quasiCounter} = u(:,quasiCounter);
    end
end
% Boundary conditions part
ab = N.dom.ends;
a = ab(1); b = ab(end);
xDom = chebfun('x',N.dom);

% Check whether we have a mismatch between periodic BCs
if xor(strcmpi(N.lbc,'periodic'),strcmpi(N.rbc,'periodic'))
    error('CHEBOP:linearise:periodic', 'BC is periodic at one end but not at the other.');
end

% Need to treat periodic BCs specially
if strcmpi(N.lbc,'periodic')
    linBC = 'periodic';
else
    % Left BC
    if ~isempty(N.lbc)
        if ~iscell(N.lbc), lbc = {N.lbc};   % wrap singleton in cell
        else lbc = N.lbc;
        end
        l = 1;
        for j = 1:length(lbc)
            if numberOfInputVariables > 1
                guj = lbc{j}(uCell{:});
            else
                guj = lbc{j}(u);
            end
            for k = 1:numel(guj);
                [Dgujk nonConst] = diff(guj(:,k),u);
                if any(nonConst),  isLin = 0;   end
                if ~isLin && flag == 1, return, end
                linBC.left(l) = struct('op',Dgujk,'val',-guj(a,k));
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
            if numberOfInputVariables > 1
                guj = rbc{j}(uCell{:});
            else
                guj = rbc{j}(u);
            end
            for k = 1:numel(guj);
                [Dgujk nonConst] = diff(guj(:,k),u);
                if any(nonConst),  isLin = 0;   end
                if ~isLin && flag, return,      end
                linBC.right(l) = struct('op',Dgujk,'val',-guj(b,k));
                l = l+1;
            end
        end
    else
        linBC.right = struct([]);
    end
end

% Functional part
try
    if numberOfInputVariables > 1
        % If we have more than one variables, we know that the first one
        % must be the linear function on the domain.
        uTemp = [{xDom} uCell];
        Nu = N.op(uTemp{:});
    else
        Nu = N.op(u);
    end
    [L nonConst] = diff(Nu,u);
catch ME
    rethrow(ME);
end
if any(any(nonConst)),  
    isLin = 0;   
else
    if nargout > 3 % Find the affine part
        if numberOfInputVariables == 1
            affine = N.op(0*x);
        else
            uZero = repmat({0*xDom},1,numberOfInputVariables-1);
            affine = N.op(xDom,uZero{:});
        end
    end
end
