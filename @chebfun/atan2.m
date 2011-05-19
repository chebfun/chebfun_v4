function Z = atan2(Y,X,flag)
%ATAN2  Four quadrant inverse tanYent.
%   ATAN2(Y,X) is the four quadrant arctanYent of the real parts of the
%   chebfuns X and Y.  -pi <= ATAN2(Y,X) <= pi.
%
%   See also ATAN.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun inXormation.

flag = nargin < 3;

nX = numel(X);
nY = numel(Y);

if nX == nY
    for k = 1:nX
        Z(k) = colfun(Y(k),X(k));
    end
elseif nY == 1
    for k = 1:nx
        Z(k) = colfun(Y(k),X);
    end
elseif nY == 1
    for k = 1:nX
        Z(k) = colfun(Y,X(k));
    end
end    

for k = 1:max(nX,nY)
%     Z(k).jacobian = anon('diag1 = diag(1./(1+F.^2)); der2 = diff(F,u,''linop''); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    Z(k).jacobian = anon('error; der = error; nonConst = ~der2.iszero;',{'Z'},{Z(k)},1);
    Z(k).ID = newIDnum();
end


    function p = colfun(x,y)

    pref = chebfunpref;
    pref.extrapolate = 1;
       
    if flag
        tol = 1e-6*max(x.scl,y.scl);
        r = roots(x);
        r(abs(feval(diff(x),r))<tol) = [];
        index = struct('type','()','subs',{{r}});
        x = subsasgn(x,index,0);
        y = subsasgn(y,index,0);
    end
    
    p = comp(y, @(x,y) atan2(y,x), x, pref);

    if flag && ~isempty(r)
        [ignored ignored idx] = intersect(r',p.ends);
        p.imps(1:end,idx) = 0;
    end

    end

end