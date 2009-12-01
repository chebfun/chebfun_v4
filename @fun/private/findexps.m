function exps = findexps(op,ends,leftrightflag,integerflag)
% EXPS markfun exponents
% EXPS = FINDEXPS(H,ENDS) returns a vector EXPS such that
% H(X).*(X-ENDS(1)).^EXPS(1).*(X+ENDS(2)).^EXPS(2) is a bounded function

% Rodrigo Platte & Nick Hale  2009

if nargin < 3, leftrightflag = 0; end
if nargin < 4, integerflag = 2; end

if integerflag == 0
    if leftrightflag, exps = 0;
    else exps = [0 0]; end
    return
end

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
        if ~leftrightflag, exps = [0 0]; else exps = 0; end
        return
    end
end

exps = [];
if leftrightflag <= 0 
    if integerflag == 2
        exps = determineExponentL(g);         % Get exponent at left point
    else
        exps = determineExponentL(g);         % Look only for integer powers
    end
end
if leftrightflag >= 0
    if integerflag == 2
        exps = [exps determineExponentL(@(x) g(-x))];         % Get exponent at right point
    else
        exps = [exps determineExponentL(@(x) g(-x))];         % Look only for integer powers
    end
end

warning(dbz_state);
