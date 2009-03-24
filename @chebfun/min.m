function [y,x] = min(f,g,dim)
% MIN   Minimum value or pointwise min function.
% MIN(F) returns the minimum value of the chebfun F. 
%
% [Y,X] = MIN(F) also returns the argument (location) where the minimum 
% value is achieved. Multiple locations are not found reliably. 
% 
% H = MIN(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = min(F(x),G(x)) for all x in the
% domain of F and G. Either F or G may be a scalar.
%
% [Y,X] = MIN(F,[],DIM) operates along the dimension DIM of the quasimatrix
% F. If DIM represents the continuous variable, then Y and X are vectors.
% If DIM represents the discrete dimension, then Y is a chebfun and X is
% undefined. The default for DIM is 1, unless F has a singleton dimension,
% in which case DIM is the continuous variable. 
%
% If F or G is complex-valued, absolute values are taken to determine
% minima, but the resulting values correspond to those of the original
% function(s).
%
% See also chebfun/max. 

%  Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin==2
  if nargout > 1
    error('chebfun:min:twoout',...
      'Min with two inputs and two outputs is not supported.')
  end
  y = minfun(f,g);
else   % 1 or 3 inputs
  % Provide a default for the dim argument.
  if nargin==1
    % For a single row chebfun, let dim=2. Otherwise, dim=1. 
    % This is consistent with MAX/MIN for matrices.
    if numel(f)==1 && f.trans
      dim = 2;
    else
      dim = 1;
    end
  end
  
  % Translate everthing to column quasimatrix. 
  if f(1).trans 
    dim = 3-dim; 
  end
  
  allreal = isreal(f);
  
  if dim==1
    % Take the min in the continuous variable. 
    for k = 1:numel(f)
      if allreal
        [yk,xk] = minval(f(k));
        y(1,k) = yk;  x(1,k) = xk;
      else
        [yk,xk] = minval(abs(f(k)));
        x(1,k) = xk;  y(1,k) = feval(f(k),xk);  
      end        
    end
    if f(1).trans
      y = y.'; x = x.';
    end
  elseif dim==2
    % Return the composite min function.
    y = f(1);
    for k = 2:numel(f)
      if allreal
        y = minfun(y,f(k));
      else
        y = minfun(y,f(k),1);
      end
    end
  end
  
end

end  % min function

function h = minfun(f,g,iscmpx)
% Return the function h(x)=min(f(x),g(x)) for all x.
% If one is complex, use abs(f) and abs(g) to determine which function
% values to keep. (experimental feature)
if isreal(f) && isreal(g) && nargin<3
  Fs = sign(f-g);
else
  Fs = sign(abs(f)-abs(g));
end
h = ((1-Fs)/2).*f + ((1+Fs)/2).*g ;
end

function [y,x] = minval(f)
% Return the value and argument of a min.

% If there is an impulse, return inf
ind = find(min(f.imps(2:end,:),[],1)<0,1,'first');
if ~isempty(ind), y = -inf; x = f.ends(ind); return, end

ends = f.ends;
y = zeros(1,f.nfuns); x = y;
for i = 1:f.nfuns
  a = ends(i); b = ends(i+1);
  [o,p] = min(f.funs(i));
  y(i) = o;
  x(i) = scale(p,a,b);
end
[y,I] = min(y);
x = x(I);

%Check values at end break points
ind = find(f.imps(1,:)<y);
if ~isempty(ind)
  [y, k] = min(f.imps(1,ind));
  x = ends(ind(k));
end

end

