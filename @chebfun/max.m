function [y,x] = max(f,g,dim)
% MAX   Maximum value or pointwise max function.
% MAX(F) returns the maximum value of the chebfun F. 
%
% [Y,X] = MAX(F) also returns the argument (location) where the maximum 
% value is achieved. Multiple locations are not found reliably. 
% 
% H = MAX(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = max(F(x),G(x)) for all x in the
% domain of F and G. Either F or G may be a scalar.
%
% [Y,X] = MAX(F,[],DIM) operates along the dimension DIM of the quasimatrix
% F. If DIM represents the continuous variable, then Y and X are vectors.
% If DIM represents the discrete dimension, then Y is a chebfun and X is
% undefined. The default for DIM is 1, unless F has a singleton dimension,
% in which case DIM is the continuous variable. 
%
% If F or G is complex-valued, absolute values are taken to determine
% maxima, but the resulting values correspond to those of the original
% function(s).
%
% See also chebfun/min. 
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if nargin==2
  if nargout > 1
    error('CHEBFUN:max:twoout',...
      'Max with two inputs and two outputs is not supported.')
  end
  y = maxfun(f,g);
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
    % Take the max in the continuous variable. 
    for k = 1:numel(f)
      if allreal
        [yk,xk] = maxval(f(k));
        y(1,k) = yk;  x(1,k) = xk;
      else
        [yk,xk] = maxval(abs(f(k)));
        x(1,k) = xk;  y(1,k) = feval(f(k),xk);
      end        
    end
    if f(1).trans
      y = y.'; x = x.';
    end
  elseif dim==2
    % Return the composite max function.
    y = f(1);
    for k = 2:numel(f)
      if allreal
        y = maxfun(y,f(k));
      else
        y = maxfun(y,f(k),1);
      end
    end
  end
  
end

end  % max function

function h = maxfun(f,g,ignored)
% Return the function h(x)=max(f(x),g(x)) for all x.
% If one is complex, use abs(f) and abs(g) to determine which function
% values to keep. (experimental feature)
if isreal(f) && isreal(g) && nargin<3
  Fs = sign(f-g);
else
  Fs = sign(abs(f)-abs(g));
end
h = ((Fs+1)/2).*f + ((1-Fs)/2).*g ;

% make sure jumps are not introduced in endspoints where f and g are
% smooth.
if isnumeric(f)
    [pjump, loc] = ismember(h.ends(1:end), g.ends);
elseif isnumeric(g)
    [pjump, loc] = ismember(h.ends(1:end), f.ends);
else
    [pjump, loc] = ismember(h.ends(1:end), union(f.ends,g.ends));
end
smooth = ~loc; % Location where endpints where introduced.
% If an endpoint has been introduced, make sure h is continuous there
if any(smooth)
    for k = 2:h.nfuns
        if smooth(k)
            % decides which pice is shorter and assume that is the more
            % accurate one
            %if h.funs(k-1).n < h.funs(k).n 
            %    h.funs(k).vals(1) = h.funs(k-1).vals(end);
            %else
            %    h.funs(k-1).vals(end) = h.funs(k).vals(1);
            %end
            % Take the value that is largest
            if h.funs(k-1).vals(end) > h.funs(k).vals(1)
                h.funs(k).vals(1) = h.funs(k-1).vals(end);
            else
                h.funs(k-1).vals(end) = h.funs(k).vals(1);
            end
            h.imps(1,k) = h.funs(k-1).vals(end);
        end
    end  
end

end

function [y,x] = maxval(f)
% Return the value and argument of a max.

% If there is an impulse, return inf
ind = find(max(f.imps(2:end,:),[],1)>0,1,'first');
if ~isempty(ind), y = inf; x = f.ends(ind); return, end

ends = f.ends;
y = zeros(1,f.nfuns); x = y;
for i = 1:f.nfuns
  a = ends(i); b = ends(i+1);
  [o,p] = max(f.funs(i));
  y(i) = o;
  x(i) = p;
end
[y,I] = max(y);
x = x(I);

%Check values at end break points
ind = find(f.imps(1,:)>y);
if ~isempty(ind)
  [y, k] = max(f.imps(1,ind));
  x = ends(ind(k));
end

end

