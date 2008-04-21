function Fout = floor(F)
% FLOOR Pointwise floor function.
%
% G = FLOOR(F) returns the chebfun G such that G(X) = FLOOR(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/CEIL, CHEBFUN/ROUND, CHEBFUN/FIX, FLOOR.

% Chebfun Version 2.0

Fout = F;
for k = 1:numel(F)
    Fout(k) = floorcol(F(k));
end

%------------------------------------------
function g = floorcol(f)

% Find all the integer crossings for f.
range = floor( [min(f) max(f)] );
breakpts = [];
for k = range(1)+1:range(2)
  breakpts = [ breakpts; roots(f-k) ];
end

% Sort and add the endpoints.
dom = domain(f);
breakpts = [dom(1); sort(breakpts); dom(2)];
n = length(breakpts);

% Evaluate at one point in each interval.
vals = feval(f, 0.5*(breakpts(1:n-1)+breakpts(2:n)) );

% Construct.
g = chebfun(num2cell(floor(vals)), breakpts);