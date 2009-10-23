function exps = findexps(op,ends,flag)
% EXPS markfun exponents
% EXPS = FINDEXPS(H,ENDS) returns a vector EXPS such that
% H(X).*(X-ENDS(1)).^EXPS(1).*(X+ENDS(2)).^EXPS(2) is a bounded function
%

if nargin == 2, flag = 0; end

a = ends(1); b = ends(2);     % Endpoints
s=@(x) b*(x+1)/2+a*(1-x)/2;   % Rescale to [-1,1]
g = @(x) op(s(x));

exps = [];
if flag <= 0
    exps = [exps determineExponentL(g)];  % Get exponent at left point
end
if flag >= 0
    exps = [exps determineExponentR(g)];  % Get exponent at right point
end

% Temporary fix in making blowup exps negative
exps = -exps;
