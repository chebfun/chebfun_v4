function guess = findguess(N)
% FINDGUESS Constructs initial guess for the solution of BVPs
%
% FINDGUESS starts with a quasimatrix with one column (the zero chebfun),
% then adds another column with the zero function to the quasimatrix until
% it's able to apply the operator to the quasimatrix (which means that the
% quasimatrix is then of the correct size).

guess = [];
dom = N.dom;
success = 0;
counter = 0;


while ~success && counter < 10
    % Need to create new chebfun at each step in order to have the
    % correct ID of the chebfun
    cheb0 = chebfun(0,dom);
    guess = [guess cheb0];
    % Check whether we are successful in applying the operator to the
    % function.
    try
        feval(N.op,guess);
        success = 1;
        counter = counter+1;
    catch
        counter = counter+1;
    end
end

if counter == 10
    error(['Chebop:solve:findguess: Initial guess seems to have 10 or more ' ...
        'columns in the quasimatrix. If this is really the case, set the ' ...
        'initial guess using N.guess.']);
end
% Once we have found the correct dimensions of the initial guess, try to
% find a linear function that fulfills (potentially) the Dirichlet BC
% imposed.
% Check whether a boundary happens to have no BC attached

% Extract BC functions
bcFunLeft = N.lbc;
bcFunRight = N.rbc;

if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end


% Store information about the endpoints of the domain
ab = dom.ends;
a = ab(1);  b = ab(end);

% Get values of BCs at the endpoints
leftVals = zeros(length(bcFunLeft),1);
rightVals = zeros(length(bcFunRight),1);
for j = 1:length(bcFunLeft)
    v = feval(bcFunLeft{j},guess);
    leftVals(j) = v(a);
end

for j = 1:length(bcFunRight)
    v = feval(bcFunRight{j},(guess));
    rightVals(j) = v(b);
end

% If we just have one column in our guess, perform a linear interpolation
if counter == 1
    leftY = leftVals(min(find(leftVals ~= 0)));
    rightY = rightVals(min(find(rightVals ~= 0)));
    
    if isempty(leftY)
        leftY = 0;
    end
    if isempty(rightY)
        rightY = 0;
    end
    
    guess = chebfun(-[leftY rightY],dom);
end