function Fx = feval(F,x,varargin)
% FEVAL Evaluate at point(s)
%
% FEVAL(F,X) evaluates the chebfun F at the point(s) in X.
%
% See also CHEBFUN/SUBSREF.
%

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
[X,I] = rescale(x,ends);
for i = 1:f.nfuns
   pos = find(I==i);
   if ~isempty(pos)       
       fx(pos) = feval(funs(i),X(pos));
   end
end

x=x(:)';
if size(f.imps,1) == 1
  [val,loc,pos] = intersect(x,ends);
  fx(loc) = f.imps(1,pos);
elseif any(f.imps(2,:))
  [val,loc,pos] = intersect(x,ends);
  fx(loc(any(f.imps(2:end,pos)>0,1))) = inf;
  fx(loc(any(f.imps(2:end,pos)<0,1))) = -inf;
end