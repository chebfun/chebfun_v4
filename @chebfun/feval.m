function fx = feval(f,x)
% FEVAL Evaluate at point(s)
%
% FEVAL(F,X) evaluates the chebfun F at the point(s) in X.
%
% See also CHEBFUN/SUBSREF.

% Toby Driscoll, 6 February 2008.

nfuns = length(f.funs);
ends = f.ends;
[X,I] = rescale(x,ends);
fx = zeros(size(x));
if nfuns == 0
  % This is an old safeguard. It might be removed
  ffuns = f.funs;
  fx = ffuns(X);
  warning('Safeguard in FEVAL has been used. Please contact support.')
else
  for i = 1:nfuns
    ffun = f.funs{i};
    pos = find(I==i);
    fx(pos) = ffun(X(pos));
  end
end
if any(f.imps(1,:))
  x = x(:).';
  [val,loc,pos] = intersect(x,ends);
  fx(loc(any(f.imps(:,pos)>0,1))) = inf;
  fx(loc(any(f.imps(:,pos)<0,1))) = -inf;
end
