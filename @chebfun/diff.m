function Fout = diff(F,n)
% DIFF	Differentiation of a chebfun.
% DIFF(F) is the derivative of the chebfun F. At discontinuities, DIFF
% creates a Dirac delta with coefficient equal to the size of the jump.
% Dirac deltas already existing in F will increase their degree.
%
% DIFF(F,N) is the Nth derivative of F.
%
% DIFF(F,u) where u is a chebfun returns the Jacobian of the chebfun F 
% with respect to the chebfun u. Either F or u or both can be a quasimatrix.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if nargin==1, n=1; end

if isa(n,'chebfun')
    Fout = jacobian(F,n);
else
    Fout = F;
    for k = 1:numel(F)
        Fout(k) = diffcol(F(k),n);
    end
end


% -------------------------------------------------------------------------
function F = diffcol(f,n)

if isempty(f.funs(1).vals), F=chebfun; return, end

tol = max(chebfunpref('eps')*10, 1e-14) ;

F = f;
funs = f.funs;
exps = get(f,'exps');
ends = get(f,'ends');
F.jacobian = anon(' @(u) diff(domain(f),n) * jacobian(f,u)',{'f' 'n'},{f n});
F.ID = newIDnum;
for j = 1:n % loop n times for nth derivative
    
    % differentiate every piece and rescale
    for i = 1:f.nfuns
        funs(i) = diff(funs(i));
        F.scl = max(F.scl, funs(i).scl.v);
    end
    F.funs = funs;
    
    % update function values in the first row of imps:
    %if ~isinf(F.imps(1,1))
    %    if exps(1,1) < 0
    %        F.imps(1,1) = inf;
    %    else
    %        F.imps(1,1) = feval(F.funs(1),ends(1));      
    %    end
    %%end
    %%for i=2:F.nfuns
    %    if ~isinf(F.imps(1,i))
    %        if (exps(i-1,2)<0 || exps(i,1)<0)       
    %            F.imps(1,i) = inf;
    %        else
    %            F.imps(1,i) = .5*(feval(F.funs(i-1),ends(i))+feval(F.funs(i),ends(i)));
    %        end
    %    end
    %end
    %if ~isinf(F.imps(1,end))
    %    if exps(end,2) < 0
    %        F.imps(1,end) = inf;
    %    else
    %        F.imps(1,end) = feval(F.funs(F.nfuns),ends(end));      
    %    end
    %end   

    F.imps(1,:) = jumpvals(F.funs,ends);
    
    % Detect jumps in the function
    fright = f.funs(1);
    newimps = zeros(1,f.nfuns+1);
    for i = 2:f.nfuns
        fleft = fright; fright = f.funs(i);
        jmp = fright.vals(1) - fleft.vals(end);
        if abs(jmp) > tol*f.scl
           newimps(i) = jmp;
        end
    end
    
    % update imps
    if size(F.imps,1)>1
       F.imps=[F.imps(1,:); newimps; F.imps(2:end,:)];
    elseif any(newimps)
      F.imps(2,:)= newimps;
    end
    
    f = F;
    
end

% update scale in funs
for k = 1:F.nfuns
    F.funs(k).scl.v = F.scl;
end