function isz = iszero(A,inspect)
% ISZERO Check for the zero operator.
%
% ISZ = ISZERO(L) returns 1 if the linop L is the zero linop on its
% domain of definition, 0 otherwise. For block linops, ISZ will be a 
% matrix with entries 1 or zero corresponding to each block. 
%
% By default this information is only extracted from the L.iszero field
% to force an inspection of the linop use the command ISZERO(L,'inspect').

% Copyright 2008 by the Chebfun Team.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

dimExpand = 10;

% We don't want to inspect, just get the flag back.
if nargin < 2 || ~strcmp(inspect,'inspect')
    isz = A.iszero;
    return
end

% If the flag says it's zero, it definitely is!
if all(A.iszero(:)), isz = A.iszero; return, end

% We're going to have to get our hands dirty. Expand the linop.
Aexpand = full(feval(A,dimExpand));

% Do the inspection.
isz = A.iszero;
for rowcounter = 1:A.blocksize(1)
    for colcounter = 1:A.blocksize(2)
        if ~A.iszero(rowcounter,colcounter)
            isz(rowcounter,colcounter) =  ...
                norm(Aexpand(1+(rowcounter-1)*dimExpand:rowcounter*dimExpand, ...
                1+(colcounter-1)*dimExpand:colcounter*dimExpand)) == 0;
        end
    end
end

end
