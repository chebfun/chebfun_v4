function [y,x] = range(f)
% RANGE Range of chebfun
%  Y = RANGE(F) returns the range of the chebfun F such that Y(1) = min(F)
%  and Y(2) = max(F).
%
%  [Y X] = RANGE(F) returns also points X such that F(X(j)) = Y(j), j =
%  1,2.
%
%  [Y X] = RANGE(F) where F is a quasimatrix returns matrice for Y an X.
%
%  See also chebfun/max chebfun/min. 
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~isreal(f)
    error('chebfun:range:notreal','Complex chebfuns are not supported in range');
end
  
% Take the max in the continuous variable.
nf = numel(f);
y = zeros(nf,2);  x = y;
for k = 1:nf
    [yk,xk] = rval(f(k));
    y(k,:) = yk;  x(k,:) = xk;   
end
if ~f(1).trans
    y = y.';      x = x.';
end

end  % range function

function [y,x] = rval(f)

y = [inf -inf];
x = [inf inf];

% negative impulse, return y(1) = -inf
ind = find(min(f.imps(2:end,:),[],1)<0,1,'first');
if ~isempty(ind), y(1) = -inf; x(1) = f.ends(ind); end
% positive impulse, return y(2) = -inf
ind = find(max(f.imps(2:end,:),[],1)>0,1,'first');
if ~isempty(ind), y(2) = inf; x(2) = f.ends(ind); end

if all(isfinite(x)), return, end
    
ends = f.ends;
yy = [zeros(f.nfuns,2) ; y];
xx = [zeros(f.nfuns,2) ; x];
for i = 1:f.nfuns
  a = ends(i); b = ends(i+1);
  [yk, xk] = range(f.funs(i));
  yy(i,:) = yk;
  xx(i,:) = scale(xk,a,b);
end
[y(1),I1] = min(yy(:,1));
[y(2),I2] = max(yy(:,2));

x(1) = xx(I1); x(2) = xx(I2);

%Check values at end break points
ind = find(f.imps(1,:) < y(1));
if ~isempty(ind)
  [y(1), k] = min(f.imps(1,ind));
  x(1) = ends(ind(k));
end

%Check values at end break points
ind = find(f.imps(1,:) > y(2));
if ~isempty(ind)
  [y(2), k] = max(f.imps(1,ind));
  x(2) = ends(ind(k));
end

end

