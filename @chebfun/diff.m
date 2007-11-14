function F = diff(f,n)
% DIFF	Differentiation
% DIFF(F) is the derivative of the chebfun F. At discontinuities, DIFF
% creates a Dirac delta with factor equal to the size of the jump. Dirac
% deltas already existing in F will increase their degree.
%
% DIFF(F,N) is the N-th derivative of F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (nargin==1) n=1; end
nfuns = length(f.funs);
ends = f.ends;
F = chebfun;
F.ends = f.ends;
for j = 1:n % loop n times for nth derivative
    for i = 1:nfuns % differentiate every piece and rescale
        a = ends(i); b = ends(i+1);
        F.funs{i} = diff(f.funs{i})*(2/(b-a));
    end
    % Detect jumps in the function
    fright = f.funs{1};
    newimps = [fright(-1) zeros(1,nfuns)];
    vs = vscale(f);
    for i = 2:nfuns
        fleft = fright; fright = f.funs{i};
        jmp = fright(-1) - fleft(1);
        if abs(jmp) > 1e-14*vs
           newimps(i) = jmp;
        end
    end
    if any(f.imps(1,:)>1e-14*vs)
        % Increase the degree of existing Dirac deltas
        F.imps = [newimps;f.imps];
    else
        % If not existing Dirac deltas, the new impulses are of first degree 
        F.imps = newimps;
    end
    f = F;
end
