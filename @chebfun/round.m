function Fout = round(f)
% ROUND   Round pointwise to nearest integer.
%
% G = ROUND(F) returns the chebfun G such that G(X) = ROUND(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/FIX, CHEBFUN/FLOOR, CHEBFUN/CEIL, ROUND.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = f;
for k = 1:numel(f)
    Fout(k) = roundcol(f(k));
end


%---------------------------
function g = roundcol(f)

if isempty(f), g=chebfun; return, end

if any(get(f,'exps')), error('CHEBFUN:round:inf',...
        'Round is not defined for functions which diverge to infinity'); end

% Find all the half-integer crossings for f.
range = round( [min(f) max(f)] );
breakpts = [];
for k = range(1)+1:range(2)
  breakpts = [ breakpts; roots(f-k+0.5) ];
end

% Sort, and add the endpoints.
dom = domain(f);
breakpts = [dom(1); sort(breakpts); dom(2)];
n = length(breakpts);

% Evaluate at one point in each interval.
vals = feval(f, 0.5*(breakpts(1:n-1)+breakpts(2:n)) );

% Construct.
g = chebfun(num2cell(round(vals)), breakpts);
g.trans = f.trans;
