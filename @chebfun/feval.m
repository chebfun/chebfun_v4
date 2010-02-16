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
   I = x > ends(i) & x < ends(i+1);
   if any(I(:))       
       fx(I) = feval(funs(i),x(I));
   end
end
I = x > ends(f.nfuns+1);
if any(I(:))
    fx(I) =  feval(funs(f.nfuns),x(I));
end

if any(f.imps(1,:))
    % RodP and NickH used this to fix the problem
    % when repeated values of x intersect with ends.
    if f.nfuns < 10
        for k = 1:f.nfuns+1
            fx( x==ends(k) ) = f.imps(1,k);
        end
    else
          [val,loc,pos] = intersect(x,ends);
          for k = 1:length(pos)
              fx( x == ends(pos(k)) ) = f.imps(1,pos(k));
          end
    end
end

% NickH fixed this also for the case when there imps has two rows.
if size(f.imps,1) > 1 && any(f.imps(2,:))
  [val,loc,pos] = intersect(xin,ends);
  for k = 1:length(pos)
      
%       % This might not be right ...
%       if any(f.imps(2:end,pos(k)) < 0)
%           fx( x == ends(pos(k)) ) = -inf;
%       elseif any(f.imps(2:end,pos(k)) > 0)
%           fx( x == ends(pos(k)) ) = inf;
%       end
      
      % We take the sign of the largest degree impulse?
      [I J sgn] = find(f.imps(2:end,pos(k)),1,'last');
      if isempty(sgn)
          % do nothing
      elseif sgn < 0
          fx( x == ends(pos(k)) ) = -inf;
      elseif sgn > 0
          fx( x == ends(pos(k)) ) = inf;
      end

  end

end




