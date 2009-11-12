function F = add_breaks_at_roots(F,tol)
% Adds new breakpoints at the root sof a chebfun

if nargin == 1,
    tol = 50*chebfunpref('eps');
end

% Add new break points at zeros
ends = get(F,'ends');
r = roots(F);

% Prune out ones that are near to existing breakpoints

for k = 1:length(r)
    nearends = min(abs(r(k)-ends));
    if nearends < tol, r(k) = NaN; end
end
r(isnan(r)) = [];

% A new chebfun with the right breaks
ends = union(ends,r);
F = chebfun(F,ends);