function isz = iszero(A)
% ISZERO Check for the zero operator.
%
% ISZ = ISZERO(L) returns 1 if the linop L is the zero linop on its
% domain of definition, 0 otherwise.

% Copyright 2008 by the Chebfun Team.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

dimExpand = 10;
Aexpand = full(feval(A,dimExpand));

if all(A.iszero(:)), isz = A.iszero; return, end

isz = zeros(A.blocksize(1),A.blocksize(2));
for rowcounter = 1:A.blocksize(1)
    for colcounter = 1:A.blocksize(2)
        isz(rowcounter,colcounter) = norm(Aexpand(1+(rowcounter-1)*dimExpand:rowcounter*dimExpand,1+(colcounter-1)*dimExpand:colcounter*dimExpand)) == 0;
    end
end

end
