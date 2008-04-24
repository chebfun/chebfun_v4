function Fout = fix(F)
% FIX Pointwise fix function.
%
% G = FIX(F) returns the chebfun G such that G(X) = FIX(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/ROUND, CHEBFUN/CEIL, CHEBFUN/FLOOR, FIX.

% Chebfun Version 2.0

Fout = F;
for k = 1:numel(F)
    Fout(k) = fixcol(F(k));
end


%---------------------------
function g =fixcol(f)

if isempty(f), g=chebfun; end

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
g = chebfun(num2cell(fix(vals)), breakpts);
g.trans = f.trans;