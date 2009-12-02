function C = mtimes(A,B)
% MTIMES * nonlinop multiplication
%
% If A and B are nonlinops, then C = A*B is a nonlinop where the operator
% of C is the composition of the operators of A and B. This operations does
% not preserve information about boundary conditions.
%
% If either A or B are scalar, then C = A*B is a nonlinop where the
% operator of C is the multiple of the operator of A or B with the scalar.
%
% If N is a nonlinop and U a chebfun, use N(u) to apply the operator N to
% U. N*U is also a permitted syntax.
%
% See also nonlinop/mldivide.

% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

if isa(A,'chebfun')
    error('Nonlinop:mtimes:invalid',['Left multiplication of a chebfun to '...
        ' a nonlinop is not defined.']);
elseif isa(B,'chebfun')
    C = feval(A.op,B);
elseif isnumeric(A) || isnumeric(B)
    % Switch argument to make sure A is numeric
    if isnumeric(B)
        temp = A; A = B; B = temp;
    end
    
    C = B;
    C.op = @(u) A*C.op(u);
elseif isa(A,'nonlinop') && isa(B,'nonlinop')
    if ~(A.dom == B.dom)
        error('Nonlinop:mtimes:domaincheck: Domains of operators do not match');
    end
    
    % When L*u is allowed, these checks will not be necessary anymore
    if strcmp(A.optype,'anon_fun')
        if strcmp(B.optype,'anon_fun')
            C = nonlinop(A.dom, @(u) A.op(B.op(u)));
        else
            C = nonlinop(A.dom, @(u) A.op(B.op*u));
        end
    else
        if strcmp(B.optype,'anon_fun')
            C = nonlinop(A.dom, @(u) A.op*(B.op(u)));
        else
            C = nonlinop(A.dom, A.op*B.op);
        end        
    end
else
    
end