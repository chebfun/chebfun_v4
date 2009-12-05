function C = mtimes(A,B)
%* Chebop composition, multiplication, or application.
%
% If A and B are chebops, then C = A*B is a chebop where the operator
% of C is the composition of the operators of A and B. No boundary
% conditions are applied to C.
%
% If either A or B are scalar, then C = A*B is a chebop representing scalar
% multiplication of the original operator. In this case, boundary conditions
% are copied into the new operator. 
%
% If N is a chebop and U a chebfun, then N*U applies N to U. 
%
% See also chebop/mldivide.
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.


if isa(A,'chebfun')
    error('chebop:mtimes:invalid','Operation is undefined.');
elseif isa(B,'chebfun')
    C = feval(A.op,B);
elseif isnumeric(A) || isnumeric(B)
    % Switch argument to make sure A is numeric
    if isnumeric(B)
        temp = A; A = B; B = temp;
    end
    
    C = B;  % change this if ID's are put in chebops!
    C.op = @(u) A*C.op(u);
    C.opshow = cellfun(@(s) [num2str(A),' * (',s,')'],B.opshow,'uniform',false);
elseif isa(A,'chebop') && isa(B,'chebop')
    if ~(A.dom == B.dom)
        error('chebop:mtimes:domain','Domains of operators do not match');
    end
    
    % When L*u is allowed, these checks will not be necessary anymore
    if strcmp(A.optype,'anon_fun')
        if strcmp(B.optype,'anon_fun')
            C = chebop(A.dom, @(u) A.op(B.op(u)));
        else
            C = chebop(A.dom, @(u) A.op(B.op*u));
        end
    else
        if strcmp(B.optype,'anon_fun')
            C = chebop(A.dom, @(u) A.op*(B.op(u)));
        else
            C = chebop(A.dom, A.op*B.op);
        end        
    end
    
    C.opshow = cellfun(@(s,t) [s, ' composed with ',t],A.opshow,B.opshow,...
      'uniform',false);
else
    
end