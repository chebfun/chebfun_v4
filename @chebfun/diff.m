function F = diff(F,n,dim)
%DIFF   Differentiation of a chebfun.
% DIFF(F) is the derivative of the chebfun F. At discontinuities, DIFF
% creates a Dirac delta with coefficient equal to the size of the jump.
% Dirac deltas already existing in F will increase their degree.
%
% DIFF(F,N) is the Nth derivative of F.
%
% DIFF(F,ALPHA) when ALPHA is not an integer offers some support for 
% fractional derivatives (of degree ALPHA) of F.
%
% DIFF(F,U) where U is a chebfun returns the Jacobian of the chebfun F 
% with respect to the chebfun U. Either F, U, or both can be a quasimatrix.
%
% DIFF(U,N,DIM) is the Nth difference function along dimension DIM. 
%      If N >= size(U,DIM), DIFF returns an empty chebfun.
%
% See also chebfun/fracdiff, chebfun/diff
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

% Check inputs
if nargin == 1, n = 1; end
if nargin < 3, dim = 1+F(1).trans; end
if ~(dim == 1 || dim == 2)
    error('CHEBFUN:diff:dim','Input DIM should take a value of 1 or 2');
end

if isa(n,'chebfun')     
    % AD
    F = jacobian(F,n);
    
elseif round(n)~=n      
    % Fractional derivatives
    F = fraccalc(diff(F,ceil(n)),ceil(n)-n);
%     F = diff(fraccalc(F,ceil(n)-n),ceil(n));

elseif dim == 1+F(1).trans
    % Differentiate along continuous variable
    for k = 1:numel(F)
        F(k) = diffcol(F(k),n);
    end
    
else
    % Diff along discrete dimension
    if numel(F) <= n, F = chebfun; return, end % Return empty chebfun
    if F(1).trans
        for k = 1:n
            F = F(2:end,:)-F(1:end-1,:);
        end 
    else
        for k = 1:n
            F = F(:,2:end)-F(:,1:end-1);
        end 
    end
    
end

% -------------------------------------------------------------------------
function F = diffcol(f,n)
% Differentiate column along continuous variable to an integer order 

if isempty(f.funs(1).vals), F=chebfun; return, end

tol = max(chebfunpref('eps')*10, 1e-14) ;

F = f;
funs = f.funs;
ends = get(f,'ends');
F.jacobian = anon(' @(u) diff(domain(f),n) * diff(f,u)',{'f' 'n'},{f n});
F.ID = newIDnum;

c = cell(1,f.nfuns);
for i = 1:f.nfuns
    c{i} = chebpoly(funs(i));
end

for j = 1:n % loop n times for nth derivative
    
    % differentiate every piece and rescale
    for i = 1:f.nfuns
        [funs(i) c{i}] = diff(funs(i),1,c{i});
        F.scl = max(F.scl, funs(i).scl.v);
    end
    F.funs = funs;

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
