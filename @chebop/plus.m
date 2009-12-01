function C = plus(A,B)
% +  Sum of chebops.
% If A and B are chebops, A+B returns the chebop that represents their
% sum. If one is a scalar, it is interpreted as the scalar times the
% identity operator.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

%  Last commit: $Author: platte $: $Rev: 840 $:
%  $Date: 2009-11-27 18:01:24 -0500 (Fri, 27 Nov 2009) $:


if isa(A,'double')
    C=A; A=B; B=C;    % swap to make A a chebop
end

% Scalar expansion using identity.
if isnumeric(B)
    if numel(B) == 0  % chebob + [] = chebop
        C = A; 
    elseif numel(B)==1
        if B==0, C=A; return
        elseif diff(A.blocksize)~=0
            error('chebop:plus:expandsquare',...
                'Scalars can be added only to square chebops.')
        end
        m = A.blocksize(1);
        B = B*blockeye(domain(A),m);
        C = A+B;
        C = setbc(C,getbc(A));
    elseif size(B,1) == size(B,2)
        if A.numbc > 0
            A = feval(A,size(B,1),'bc');
        else
            A = feval(A,size(B,1));
        end
        C = A+B;
    end
    return
end

if isa(B,'chebop') % Chebop + chebop
    dom = domaincheck(A,B);

    % If one chebop happens to be the zero chebop, we return the other one 
    if iszero(A)
        C = B;
        return
    elseif iszero(B)
        C = A;
        return
    end

    
    if ~all(A.blocksize==B.blocksize)
        error('chebop:plus:sizes','Chebops must have identical sizes.')
    end
    
    op = A.oparray + B.oparray;
    order = max( A.difforder, B.difforder );
    C = chebop( A.varmat+B.varmat, op, dom, order );
    C.blocksize = A.blocksize;
    
else
    error('chebop:plus:badoperand','Unrecognized operand.')
    
end

end