function isz = iszero(A)
% ISZERO Check whether a chebop is the zero chebop on its domain of
% definition.
%
% ISZ = ISZERO(L) returns 1 if the chebop L is the zero chebop on its
% domain of definition, 0 otherwise.

if norm(full(feval(A,10))) == 0
    isz = 1;
else
    isz = 0;
end


end
