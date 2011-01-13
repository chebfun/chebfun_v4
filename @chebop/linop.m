function L = linop(N,u)
%LINOP Converts a chebop N to a linop L if N is a linear operator

% This is simply a wrapper for @chebop/private/linearise.m

% For expm, we need to be able to linearize around u = 0, so we offer the
% option of linearizing around a certain function here (similar to diff),
% the difference is that we check for linearity in this method as well.
if nargin == 1
    if isempty(N.dom)
        error('CHEBFUN:chebop:linop:emptydomain', ...
            'Cannot linearise a chebop defined on an empty domain.'); 
    end
%   Create a chebfun to let the operator operate on. Using the findguess
%   method ensures that the guess is of the right (quasimatrix) dimension.
    u = findguess(N);
end

[L bc isLin] = linearise(N,u,1);

if isLin
    L = L&bc;
else
    error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
end