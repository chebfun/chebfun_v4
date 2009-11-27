function exps = findexps(op,ends,flag)
% EXPS markfun exponents
% EXPS = FINDEXPS(H,ENDS) returns a vector EXPS such that
% H(X).*(X-ENDS(1)).^EXPS(1).*(X+ENDS(2)).^EXPS(2) is a bounded function

% Rodrigo Platte?  2009

if nargin == 2, flag = 0; end

dbz_state = warning('off','MATLAB:divideByZero');   % turn off warning because of removable sings

a = ends(1); b = ends(2);     % Endpoints
if ~any(isinf(ends))
    s=@(x) b*(x+1)/2+a*(1-x)/2;   % Rescale to [-1,1]
    gends = op([a,b]);
else
    map = unbounded(ends);
    s = map.for;
    newends = adjustends([-1,1],a,b);
    gends = op(newends);
end
g = @(x) op(s(x));

if ~any(isinf(gends))
    xvals = [ -0.616227322745569
               0.718984852785806];
    gvals = g(xvals);
    if norm(gends,inf) < 1e4*norm(gvals,inf), 
        if ~flag, exps = [0 0]; else exps = 0; end
        return
    end
end

exps = [];
if flag <= 0 
    exps = determineExponentL(g);         % Get exponent at left point
end
if flag >= 0
    exps = [exps determineExponentL(@(x) g(-x))];  % Get exponent at right point
end

warning(dbz_state);
