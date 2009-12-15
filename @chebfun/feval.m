function Fx = feval(F,x,varargin)
% FEVAL   Evaluate a chebfun at one or more points.
% FEVAL(F,X) evaluates the chebfun F at the point(s) in X.
%
% See also CHEBFUN/SUBSREF.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 


% Because chebfuns are superior to function_handle, this call can result
% when f is function_handle and x is chebfun. In that case, revert to the
% built-in behavior.

if isa(F,'function_handle')
  Fx = F(x,varargin{:});
  return
end

if isempty(F), Fx=[]; return, end

% Deal with quasimatrices.
nchebs = numel(F);
if nchebs>1, 
    x=x(:); Fx=[];
    for k = 1:nchebs
        trans=F(1).trans;
        if trans
            Fx = [Fx; fevalcolumn(F(k),x')];
        else
            Fx = [Fx fevalcolumn(F(k),x)];
        end
    end
else
    Fx = fevalcolumn(F,x);
end
    

% Evaluate a single chebfun
% ------------------------------------------
function fx = fevalcolumn(f,x)

fx = zeros(size(x));

funs=f.funs;
ends = f.ends;
xin=x(:).';

I = x < ends(1);
if any(I(:))
    fx(I) =  feval(funs(1),x(I));
end
for i = 1:f.nfuns
   I = x>=ends(i) & x<=ends(i+1);
   if any(I(:))       
       fx(I) = feval(funs(i),x(I));
   end
end
I = x > ends(f.nfuns+1);
if any(I(:))
    fx(I) =  feval(funs(f.nfuns),x(I));
end

if size(f.imps,1) == 1
    % This doesn't work if repeated values of x intersect with ends.
    %[val,loc,pos] = intersect(xin,ends);
    %fx(loc) = f.imps(1,pos);
    % RodP and NickH replacing with this to fix the problem
    if f.nfuns < 10
        for k = 1:f.nfuns+1
            fx( x==ends(k) ) = f.imps(1,k);
        end
    else
          [val,loc,pos] = intersect(x,ends);
          for k = 1:length(pos)
              fx( x == ends(pos(k)) ) = f.imps(1,pos(k));
          end
           
%         % Below doesn't work with repeated multiple breakpoint evalutions. 
%         % Would need to find indices where j == loc
%         [xu i j] = unique(x);
%         [val,loc,pos] = intersect(xu,ends);
%         fx(j(loc)) = f.imps(1,pos);
   end
    % ---- End fix (to be revisited in the near future) ---

  
elseif any(f.imps(2,:))
  [val,loc,pos] = intersect(xin,ends);
  fx(loc(any(f.imps(2:end,pos)>0,1))) = inf;
  fx(loc(any(f.imps(2:end,pos)<0,1))) = -inf;
end