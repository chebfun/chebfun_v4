function F = add_breaks_at_roots(F,tol,r)
% Adds new breakpoints at the root sof a chebfun

if nargin == 1 || isempty(tol),
    tol = 50*chebfunpref('eps');
end

% Add new break points at zeros
ends = get(F,'ends');
if nargin < 3
    r = roots(F);
elseif isempty(r)
    return
end

% Prune out ones that are near to existing breakpoints
for k = 1:length(r)
    nearends = min(abs(r(k)-ends));
    if nearends < tol, r(k) = NaN; end
end
r(isnan(r)) = [];

% A new chebfun with the right breaks
newends = union(ends,r);

if length(newends)~= length(ends)
%     F = chebfun(F,newends);
      index = struct('type','()','subs',{{newends}});
      F = subsasgn(F,index,feval(F,newends));
end