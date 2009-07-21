function Fout = diff(F,n)
% DIFF	Differentiation of a chebfun.
% DIFF(F) is the derivative of the chebfun F. At discontinuities, DIFF
% creates a Dirac delta with coefficient equal to the size of the jump.
% Dirac deltas already existing in F will increase their degree.
%
% DIFF(F,N) is the Nth derivative of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin==1, n=1; end

Fout = F;
for k = 1:numel(F)
    Fout(k) = diffcol(F(k),n);
end


% -------------------------------------------------------------------------
function F = diffcol(f,n)

if isempty(f.funs(1).vals), F=chebfun; return, end

tol = max(chebfunpref('eps')*10, 1e-14) ;

F = f;
funs = f.funs;

for j = 1:n % loop n times for nth derivative
    
    % differentiate every piece and rescale
    for i = 1:f.nfuns 
        funs(i) = diff(funs(i));
        F.scl = max(F.scl, funs(i).scl.v);
    end
    F.funs = funs;

    % update function values in the first row of imps:
    for i=1:F.nfuns
        F.imps(1,i) = F.funs(i).vals(1);
    end
    F.imps(1,end) = F.funs(F.nfuns).vals(end);
    
    
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
