function Fout = diff(F,n)
% DIFF	Differentiation of a chebfun.
% DIFF(F) is the derivative of the chebfun F. At discontinuities, DIFF
% creates a Dirac delta with factor equal to the size of the jump. Dirac
% deltas already existing in F will increase their degree.
%
% DIFF(F,N) is the N-th derivative of F.
% 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin==1, n=1; end

Fout = F;
for k = 1:numel(F)
    Fout(k) = diffcol(F(k),n);
end


% -------------------------------------------------------------------------
function F = diffcol(f,n)

if isempty(f), F=chebfun; return, end

ends = f.ends;
F = f;
funs = f.funs;

for j = 1:n % loop n times for nth derivative
    
    % differentiate every piece and rescale
    for i = 1:f.nfuns 
        a = ends(i); b = ends(i+1);
        funs(i) = diff(funs(i))*(2/(b-a));
    end
    F = set(F, 'funs', funs);

    % update function values in the first row of imps:
    for i=1:F.nfuns
        F.imps(1,i)=feval(F.funs(i),-1);
    end
    F.imps(1,end)=feval(F.funs(F.nfuns),1);
    
    
    % Detect jumps in the function
    fright = f.funs(1);
    newimps = zeros(1,f.nfuns+1);
    for i = 2:f.nfuns
        fleft = fright; fright = f.funs(i);
        jmp = feval(fright,-1) - feval(fleft,1);
        if abs(jmp) > 1e-12*f.scl
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