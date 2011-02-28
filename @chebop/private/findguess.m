function guess = findguess(N,fitBC)
% FINDGUESS Constructs initial guess for the solution of BVPs
%
% FINDGUESS starts with a quasimatrix with one column (the zero chebfun),
% then adds another column with the zero function to the quasimatrix until
% it's able to apply the operator to the quasimatrix (which means that the
% quasimatrix is then of the correct size).

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% If we don't pass the parameter fitBC, we assume that we want to try to
% fit to BCs. The opposite is true when we try to linearise a chebop.
if nargin == 1, fitBC = 1; end

guess = [];
dom = N.dom;
xDom = chebfun('x',dom);
Ndim = N.dim;
success = 0;
counter = 0;


% If N.op takes multiple arguments (i.e. on the form @(x,u,v)), we know how
% many columns we'll be needing in the quasimatrix. We also know that the
% linear function x will be the first argument.
NopArgin = nargin(N.op);

if NopArgin > 1
    success = 1;
    
    for quasiCounter = 2:NopArgin
        cheb0 = chebfun(0,dom);
        guess = [guess cheb0];
    end
    
end

if NopArgin == 1 && ~isempty(Ndim)
    success = 1;
    
    for quasiCounter = 1:Ndim
        cheb0 = chebfun(0,dom);
        guess = [guess cheb0];
    end
end

% Won't be called if NopArgin > 1 since then we are already successful
while ~success && counter < 10
    % Need to create new chebfun at each step in order to have the
    % correct ID of the chebfun
    cheb0 = chebfun(0,dom);
    guess = [guess cheb0];
    
    
    % Check whether we are successful in applying the operator to the
    % function.
    try
        if NopArgin == 1
            feval(N.op,guess);
        else
            guessTemp = [xDom guess];
            feval(N.op,guessTemp{:});
        end
        success = 1;
        counter = counter+1;
    catch
        ME = lasterror;
        if strcmp(ME.identifier,'CHEBFUN:mtimes:dim') || strcmp(ME.identifier,'MATLAB:badsubscript')
            counter = counter + 1;
        elseif strcmp(ME.identifier,'CHEBFUN:rdivide:DivisionByZeroChebfun')
            error('CHEBOP:solve:findguess:DivisionByZeroChebfun', ...
                ['Error in constructing initial guess. The the zero function ', ...
                'on the domain is not a permitted initial guess as it causes ', ...
                'division by zero. Please assign an initial guess using the ', ...
                'N.init field.']);
        else
            error('CHEBOP:solve:findguess:ZeroFunctionNotPermitted', ...
                ['Error in constructing initial guess. The zero function ', ...
                'appears not to be valid as an argument to the operator. ', ....
                'Please assign an initial guess using the N.init field.']);
        end
    end
end

if counter == 10
    error('CHEBOP:solve:findguess', ['Initial guess seems to have 10 or more ' ...
        'columns in the quasimatrix. If this is really the case, set the ' ...
        'initial guess using N.init.']);
end

if fitBC
    % Once we have found the correct dimensions of the initial guess, try to
    % find a linear function that fulfills (potentially) the Dirichlet BC
    % imposed.
    % Check whether a boundary happens to have no BC attached
    
    % Extract BC functions
    bcFunLeft = N.lbc;
    bcFunRight = N.rbc;
    
    if success && ~any(strcmpi(bcFunLeft,'periodic')) && ~any(strcmpi(bcFunRight,'periodic'))
        guess = tryInterpGuess();
    elseif xor(strcmpi(bcFunLeft,'periodic'),strcmpi(bcFunRight,'periodic'))
        error('CHEBOP:mldivide:findguess: BC is periodic at one end but not at the other.');
    end
end
    function intGuess = tryInterpGuess()
        % For some type of problems (nonperiodic problems where the
        % solution is a single chebfun rather then quasimatrix) we can try
        % to construct an initial guess such that it satisfies
        % (potentially) non-homogenous Dirichlet BCs. If we are working
        % with quasimatrices, we do not try to construct a guess. !!!Should
        % use AD information see what BCs depends on what variables.
        intGuess = guess; % Default returned chebfun
        
        leftEmpty = isempty(bcFunLeft);
        rightEmpty = isempty(bcFunRight);
        
        % Store information about the endpoints of the domain
        ab = dom.ends;
        a = ab(1);  b = ab(end);
        
        
        % Get values of BCs at the endpoints
        leftVals = zeros(length(bcFunLeft),1);
        rightVals = zeros(length(bcFunRight),1);
        
        % Create a cell variable, allows syntax like @(u,v)
        guessCell = cell(1,numel(guess));
        for quasiCounter = 1:numel(guess)
            guessCell{quasiCounter} = guess(:,quasiCounter);
        end
        
        if leftEmpty
            leftVals = 0;
        else
            if nargin(bcFunLeft) > 1, return, end
            v = bcFunLeft(guessCell{:});
            leftVals = v(a,:);
        end
        
        if rightEmpty
            rightVals = 0;
        else
            if nargin(bcFunRight) > 1, return, end
            v = bcFunRight(guessCell{:});
            rightVals = v(b,:);
        end
        % If we just have one column in our guess, perform a linear interpolation
        leftY = leftVals(min(find(leftVals ~= 0)));
        rightY = rightVals(min(find(rightVals ~= 0)));
        
        if isempty(leftY)
            leftY = 0;
        end
        if isempty(rightY)
            rightY = 0;
        end
        
        intGuess = chebfun(-[leftY rightY],dom);
    end

end