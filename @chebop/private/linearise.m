function [L linBC isLin affine] = linearise(N,u,flag)
%LINEARISE   Linearise a chebop.
% [L linBC isLin] = LINEARISE(N,u) Linearises the chebop N about the
% chebfun u.
%
% LINEARISE(N,U,1) is simply a islinear check, so we kick out if
% nonlinearity is detected (and return garbage in L and linBC). (This is
% also used by chebop/linop which returns an error when the chebop is
% nonlinear).

% Copyright 2011 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

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
L = [];
linBC = [];
affine = [];
cheb1 = chebfun('1',N.dom);
nonLinFlag = 0;

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
            % Evaluate the BC function
            if numberOfInputVariables > 1
                try
                    % If errorString will not be empty below the second
                    % next line (guj = ...), it means that that evaluation
                    % has failed. We use that information to throw the
                    % correct error in the catch statement.
                    errorString = [];
                    guj = lbc{j}(uCell{:});
                    
                    % If we have a system, and the user assigns BCs on the
                    % form L.lbc = @(u,v) [u-1 ; v]; rather than L.lbc =
                    % @(u,v) [u-1,v]; the domains of u and guj will not be
                    % the same. Use that to throw an error.
                    domu = domain(u);
                    domguj = domain(guj);
                    if domu(1) ~= domguj(1) || domu(end) ~= domguj(end)
                        errorString = ['Incorrect form of left BCs. Did you use ', ...
                            'BCs of the form @(u,v)[u;v] rather than @(u,v)[u,v]',...
                            '(i.e. a semicolon rather than a comma)?',...
                            '\n\nSee ''help chebop'' for details of allowed BC syntax.'];
                        error('throw me to get to the catch-statement below')
                    end
                catch
                    if ~isempty(errorString)
                        error('CHEBFUN:chebop:linearise',errorString);
                    else
                        lbcshow = {N.lbcshow};
                        lbcshow = lbcshow{j};
                        % Convert function handles to strings
                        if isa(lbcshow,'function_handle')
                            lbcshow = char(lbcshow);
                        elseif isnumeric(lbcshow)
                            lbcshow = num2str(lbcshow);
                        end
                        s = sprintf(['''%s'' boundary condition is not valid for systems of equations.',...
                            '\n\nSee ''help chebop'' for details of allowed syntax.'],lbcshow);
                        error('CHEBFUN:chebop:linearise',s);
                    end
                end
            else
                guj = lbc{j}(u);
            end
            % Compute the Frechet derivative, and look for terms on the
            % form u.*v
            if numel(u) == 1
                for k = 1:numel(guj);
                    [Dgujk nonConst] = diff(guj(:,k),u,'linop');
                    if any(nonConst),  isLin = 0;   end
                    if ~isLin && flag == 1, return, end
                    linBC.left(l) = struct('op',Dgujk,'val',-guj(a,k));
                    l = l+1;
                end
            else
                for k = 1:numel(guj);
                    Dgujk = linop; nonConst = [];
                    for uCounter = 1:numel(u)
                        [DgujkColumn nonConstColumn] = diff(guj(:,k),u(:,uCounter),'linop');
                        Dgujk = [Dgujk DgujkColumn];
                        nonConst = [nonConst nonConstColumn];
                        if any(nonConstColumn),  % If we have u.^2, we don't need to check for u*v
                            isLin = 0; nonLinFlag = 1;
                        end
                        if ~isLin && flag == 1, return, end
                        if ~nonLinFlag % Don't need to check if we've already encounterd u*v
                            newFun = DgujkColumn*cheb1;
                            for vCounter = uCounter+1:numel(u)
                                Dgujktemp = diff(newFun,u(:,vCounter),'linop');
                                if ~all(iszero(Dgujktemp))
                                    nonLinFlag = 1;
                                    break
                                end
                            end
                        end
                    end
                    linBC.left(l) = struct('op',Dgujk,'val',-guj(a,k));
                    l = l+1;
                end
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
            % Evaluate the BC function
            if numberOfInputVariables > 1
                try
                    % If errorString will not be empty below the second
                    % next line (guj = ...), it means that that evaluation
                    % has failed. We use that information to throw the
                    % correct error in the catch statement.
                    errorString = [];
                    guj = rbc{j}(uCell{:});
                    
                    % If we have a system, and the user assigns BCs on the
                    % form L.rbc = @(u,v) [u-1 ; v]; rather than L.lbc =
                    % @(u,v) [u-1,v]; the domains of u and guj will not be
                    % the same. Use that to throw an error.
                    domu = domain(u);
                    domguj = domain(guj);
                    if domu(1) ~= domguj(1) || domu(end) ~= domguj(end)
                        errorString = ['Incorrect form of right BCs. Did you use ', ...
                            'BCs of the form @(u,v)[u;v] rather than @(u,v)[u,v]',...
                            '(i.e. a semicolon rather than a comma)?',...
                            '\n\nSee ''help chebop'' for details of allowed BC syntax.'];
                        error('throw me to get to the catch-statement below')
                    end
                catch
                    if ~isempty(errorString)
                        error('CHEBFUN:chebop:linearise',errorString);
                    else
                        rbcshow = {N.rbcshow};
                        rbcshow = rbcshow{j};
                        % Convert function handles to strings
                        if isa(rbcshow,'function_handle')
                            rbcshow = char(rbcshow);
                        elseif isnumeric(rbcshow)
                            rbcshow = num2str(rbcshow);
                        end
                        s = sprintf(['''%s'' boundary condition is not valid for systems of equations.',...
                            '\n\nSee ''help chebop'' for details of allowed syntax.'],rbcshow);
                        error('CHEBFUN:chebop:linearise',s);
                    end
                end
            else
                guj = rbc{j}(u);
            end
            % Compute the Frechet derivative, and look for terms on the
            % form u.*v
            if numel(u) == 1
                for k = 1:numel(guj);
                    [Dgujk nonConst] = diff(guj(:,k),u,'linop');
                    if any(nonConst),  isLin = 0;   end
                    if ~isLin && flag == 1, return, end
                    linBC.right(l) = struct('op',Dgujk,'val',-guj(b,k));
                    l = l+1;
                end
            else
                for k = 1:numel(guj);
                    Dgujk = linop; nonConst = [];
                    for uCounter = 1:numel(u)
                        [DgujkColumn nonConstColumn] = diff(guj(:,k),u(:,uCounter),'linop');
                        Dgujk = [Dgujk DgujkColumn];
                        nonConst = [nonConst nonConstColumn];
                        if any(nonConstColumn),  % If we have u.^2, we don't need to check for u*v
                            isLin = 0; nonLinFlag = 1;
                        end
                        if ~isLin && flag == 1, return, end
                        if ~nonLinFlag % Don't need to check if we've already encounterd u*v
                            newFun = DgujkColumn*cheb1;
                            for vCounter = uCounter+1:numel(u)
                                Dgujktemp = diff(newFun,u(:,vCounter),'linop');
                                if ~all(iszero(Dgujktemp))
                                    nonLinFlag = 1;
                                    break
                                end
                            end
                        end
                    end
                    linBC.right(l) = struct('op',Dgujk,'val',-guj(b,k));
                    l = l+1;
                end
            end
        end
    else
        linBC.right = struct([]);
    end
end

% If N.op is a linop, there's nothing to do here.
if isa(N.op,'linop')
    L = N.op;
    if nargout > 3
        affine = repmat(0*xDom,1,numberOfInputVariables-1);
    end
    return
end

% Functional part
try
    if numberOfInputVariables > 1
        % If we have more than one variables, we know that the first one
        % must be the linear function on the domain.
        uTemp = [{xDom} uCell];
        Nu = N.op(uTemp{:});
        % Must check whether we have terms on the form u*v, u*w, v*w etc.
        % Construct each column of the Jacobian separately, let it operate
        % on the function 1 on the domain, then linearize around next
        % variable. If the resulting derivative is not zero, we must have
        % nonlinear terms on the form above.
        % At the same time, we accumulate the linop, one "block-column" at
        % a time.
        L = linop; nonConst = [];
        for uCounter = 1:numel(u)
            [Lcolumn nonConstColumn] = diff(Nu,u(:,uCounter),'linop');
            L = [L Lcolumn];
            nonConst = [nonConst nonConstColumn];
            if any(nonConstColumn) % If we have u.^2, we don't need to check for u*v
                nonLinFlag = 1;
            % Don't go into this part if uCounter+1 == numel(u) as the
            % for-loop won't be executed anyway.
            elseif ~nonLinFlag && (uCounter+1)<= numel(u)% Don't need to check if we've already encountered u*v
                newFun = Lcolumn*cheb1;
                for vCounter = uCounter+1:numel(u)
                    Ltemp = diff(newFun,u(:,vCounter),'linop');
                    if ~all(iszero(Ltemp))
                        nonLinFlag = 1;
                        break
                    end
                end
            end
        end
    else
        Nu = N.op(u);
        if numel(u) == 1
            [L nonConst] = diff(Nu,u,'linop');
        else % We have a quasimatrix, must to similar things as above
            L = linop; nonConst = [];
            for uCounter = 1:numel(u)
                [Lcolumn nonConstColumn] = diff(Nu,u(:,uCounter),'linop');
                L = [L Lcolumn];
                nonConst = [nonConst nonConstColumn];
                if any(nonConstColumn) % If we have u.^2, we don't need to check for u*v
                    nonLinFlag = 1;
                elseif ~nonLinFlag % Don't need to check if we've already encountered u*v
                    newFun = Lcolumn*cheb1;
                    for vCounter = uCounter+1:numel(u)
                        Ltemp = diff(newFun,u(:,vCounter),'linop');
                        if ~all(iszero(Ltemp))
                            nonLinFlag = 1;
                            break
                        end
                    end
                end
            end
        end
    end
catch
    ME = lasterror;
    rethrow(ME);
end
if nonLinFlag || any(any(nonConst)),
    isLin = 0;
    
    for lCounter = 1:numel(linBC.left)
        linBC.left(lCounter).val = -linBC.left(lCounter).val;
    end
    for rCounter = 1:numel(linBC.right)
        linBC.right(rCounter).val = -linBC.right(rCounter).val;
    end
else
    if nargout > 3 % Find the affine part
        if numberOfInputVariables == 1
            affine = N.op(0*xDom);
        else
            uZero = repmat({0*xDom},1,numberOfInputVariables-1);
            affine = N.op(xDom,uZero{:});
        end
    end
end
