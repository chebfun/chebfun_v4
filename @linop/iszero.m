function isz = iszero(A)
% ISZERO Check for the zero operator.
%
% ISZ = ISZERO(L) returns 1 if the linop L is the zero linop on its
% domain of definition, 0 otherwise.

% Copyright 2008 by the Chebfun Team.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:


if norm(full(feval(A,10))) == 0
    isz = 1;
else
    isz = 0;
end


end
