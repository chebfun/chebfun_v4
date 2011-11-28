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
    %   Create a chebfun to let the operator operate on. Using the
    %   findguess method ensures that the guess is of the right
    %   (quasimatrix) dimension.
    u = findguess(N,0); % Second argument 0 denotes we won't try to fit to BCs.
end

% Initialise The flag variable is used to denote we only want to check for
% linearity (i.e. we don't care about the derivative itself) so we return
% immediately if we encounter nonlinearity and flag == 1.
if nargin < 3, flag = 0; end
isLin = 1;
L = [];
linBC = [];
affine = [];
jumplocs = [];
nonLinFlag = 0;
dom = [];

% Check whether we are working with anonymous functions which accept
% quasimatrices or arguments such as @(u,v). In the former case, no special
% measurements have to be taken, but in the latter, in order to allow
% evaluation, we need to create a cell array with entries equal to each
% column of the quasimatrix representing the current solution.
numberOfInputVariables = nargin(N.op);
% If we have a linop and more than one variable, the independent function x
% is not one of them. In order for the code to work, we need to add 1 to
% numberOfInputVariables if isa(N.op,'linop') && numberOfInputVariables > 1
%     numberOfInputVariables = numberOfInputVariables
if numberOfInputVariables > 1 % Load a cell, with the linear function x as the first entry
    uCell = cell(1,numel(u));
    for quasiCounter = 1:numel(u)
        uCell{quasiCounter} = u(:,quasiCounter);
    end
else 
    uCell = [];
    tmp = [];
end
% Boundary conditions part
ab = N.dom.ends;
a = ab(1); b = ab(end);
xDom = chebfun('x',N.dom);

% Check whether we have a mismatch between periodic BCs
% if xor(strcmpi(N.lbc,'periodic'),strcmpi(N.rbc,'periodic'))
%     error('CHEBOP:linearise:periodic', 'BC is periodic at one end but not at the other.');
% end
% Check whether we have a mismatch between periodic BCs
if strcmpi(N.bc,'periodic') && (~isempty(N.lbc) || ~isempty(N.rbc))
    error('CHEBOP:linearise:periodic', 'BC is periodic at one end but not at the other.');
end

% Need to treat periodic BCs specially
if strcmpi(N.bc,'periodic')
    linBC = 'periodic';
else
    % Left BC
    linBC.left = lineariseBC(N.lbc,N.lbcshow,'left',a,false);
    
    % Right BC
    linBC.right = lineariseBC(N.rbc,N.rbcshow,'right',b,false);
    
    % Other BCs
    if ~isempty(N.bc)
        u = set(u,'funreturn',1);
        if numberOfInputVariables > 1 % Load a cell, with the linear function x as the first entry
            uCell2 = cell(1,numel(u));
            for quasiCounter = 1:numel(u)
                uCell2{quasiCounter} = u(:,quasiCounter);
            end
            tmp = uCell; uCell = uCell2;
        end
        linBC.other = lineariseBC(N.bc,N.bcshow,'other',a,true);
        uCell = tmp;
    else 
        linBC.other = struct([]);
    end

end

% If N.op is a linop, there's nothing to do here.
if isa(N.op,'linop')
    L = N.op;
    if nargout > 3
        affine = repmat(0*xDom,1,numberOfInputVariables-1);
    end
    if any(jumplocs==a) || any(jumplocs==b)
        error('CHEBOP:linearise:jumpbcs',...
        ['Jump conditions cannot be enforced at the boundary of the domain.\n',...
         '(Do not use ''left'' or ''right'' flags at boundaries in .bc field.)'])
    end
    L = set(L,'jumplocs',unique(jumplocs));
    return
end

% Functional part
try
    if numberOfInputVariables > 1
        % If we have more than one variables, we know that the first one
        % must be the linear function on the domain.
        if numberOfInputVariables == 2 % Then we're working with @(x,u) where u might (or not) be a quasimatrix
            Nu = N.op(xDom,u);
        else
            uTemp = [{xDom} uCell];
            Nu = N.op(uTemp{:});
        end
        % Obtain the Frechet derivative. nonConst contains information
        % about nonlinearity, including terms of the kind u.*v.
        [L nonConst] = diff(Nu,u,'linop');
    else
        Nu = N.op(u);
        [L nonConst] = diff(Nu,u,'linop');
    end
catch
    ME = lasterror;
    rethrow(ME);
end
if nonLinFlag || any(any(nonConst)),
    isLin = 0;
    if isstruct(linBC)
        for lCounter = 1:numel(linBC.left)
            linBC.left(lCounter).val = -linBC.left(lCounter).val;
        end
        for rCounter = 1:numel(linBC.right)
            linBC.right(rCounter).val = -linBC.right(rCounter).val;
        end
        for oCounter = 1:numel(linBC.other)
            linBC.other(oCounter).val = -linBC.other(oCounter).val;
        end
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

jumplocs = unique([jumplocs, N.jumplocs]);
if any(jumplocs==a) || any(jumplocs==b)
    error('CHEBOP:linearise:jumpbcs',...
    ['Jump conditions cannot be enforced at the boundary of the domain.\n',...
     '(Do not use ''left'' or ''right'' flags at boundaries in .bc field.)'])
end
L = set(L,'jumplocs',jumplocs);
Ndom = N.dom; Ldom = get(L,'fundomain');
% dom = unique([Ndom.endsandbreaks, Ldom.endsandbreaks]);
dom = unique([Ndom.endsandbreaks, Ldom.endsandbreaks, jumplocs, dom]);
L = set(L,'fundomain',domain(dom));

    function linBC = lineariseBC(bc,bcshow,lr,ab,bcflag)
        if ~isempty(bc)
            if ~iscell(bc), bc = {bc}; end  % wrap singleton in cell
            l = 1;
            for j = 1:length(bc)
                % Evaluate the BC function
                if nargin(bc{j}) > 1 + bcflag % Need to expand uCell in order to be able to evaluate
                    try
                        % If errorString will not be empty below the second
                        % next line (guj = ...), it means that that evaluation
                        % has failed. We use that information to throw the
                        % correct error in the catch statement.
                        errorString = [];
                        feval(uCell{1},[]); % Clear persistent variables starage in feval
                        if ~bcflag
                            guj = bc{j}(uCell{:});
                        else
                            guj = bc{j}(xDom,uCell{:});
                        end
                        % Feval points have been stored in feval. Recover these and reset.
                        if strcmp(lr,'other')
                            [ignored jumplocsj] = feval(uCell{1},[]);
                            jumplocs = [jumplocs jumplocsj];
                        end

                        % If we have a system, and the user assigns BCs on the
                        % form L.lbc = @(u,v) [u-1 ; v]; rather than L.lbc =
                        % @(u,v) [u-1,v]; the domains of u and guj will not be
                        % the same. Use that to throw an error.
                        domu = domain(u);
                        domguj = domain(guj);
                        if domu(1) ~= domguj(1) || domu(end) ~= domguj(end)
                            errorString = ['Incorrect form of ' lr ' BCs. Did you use ', ...
                                'BCs of the form @(u,v)[u;v] rather than @(u,v)[u,v]',...
                                '(i.e. a semicolon rather than a comma)?',...
                                '\n\nSee ''help chebop'' for details of allowed BC syntax.'];
                            error('throw me to get to the catch-statement below')
                        end
                    catch
                        if ~isempty(errorString)
                            error('CHEBFUN:chebop:linearise',errorString);
                        else
                            bcshowj = {bcshow};
                            bcshowj = bcshowj{j};
                            % Convert function handles to strings
                            if isa(bcshowj,'function_handle')
                                bcshowj = char(bcshowj);
                            elseif isnumeric(bcshowj)
                                bcshowj = num2str(bcshowj);
                            end
                            s = sprintf(['''%s'' boundary condition is not valid for systems of equations.',...
                                '\n\nSee ''help chebop'' for details of allowed syntax.'],bcshowj);
                            error('CHEBFUN:chebop:linearise',s);
                        end
                    end
                else
                    feval(u,[]); % Clear persistent variables starage in feval
                    if nargin(bc{j}) == 1
                        guj = bc{j}(u);
                    else
                        guj = bc{j}(xDom,u);
                    end
                    % Feval points have been stored in feval. Recover these and reset.
                    if strcmp(lr,'other')
                        [ignored jumplocsj] = feval(u,[]);
                        jumplocs = [jumplocs jumplocsj];
                    end
                    
                end

                % Compute the Frechet derivative of the BCs. Populate the
                % structure linBC with the linops arising.
                gujvals = feval(guj,ab,'force');
                for k = 1:numel(guj);
                    [Dgujk nonConst] = diff(guj(:,k),u,'linop');
                    if any(any(nonConst))
                        isLin = 0; nonLinFlag = 1;
                    end
                    if ~isLin && flag == 1, linBC = struct([]); return, end
                    linBC(l) = struct('op',Dgujk,'val',-gujvals(k));
                    l = l+1;
                    domk = get(Dgujk,'fundomain');
                    dom = union(dom,domk.endsandbreaks);
                end

            end
        else
            linBC = struct([]);
        end
    end

% Assign the scale to the chebop if it's not empty
if ~isempty(N.scale)
%     L.scale = N.scale;
    L = subsasgn(L,struct('type','.','subs','scale'), N.scale);
end

end