function [L f] = linop(N,u,flag)
%LINOP Converts a chebop to a linop
% L = LINOP(N) converts a chebop N to a linop L if N is a linear operator.
% If N is not linear, then an error message is returned.
%
% [L F] = LINOP(N) returns also the affine part F of the linear chebop N
% such that if, say, N.op = @(x,u), then L*u + F(x) = N.op(x,u).
%
% See also LINOP.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% This is simply a wrapper for @chebop/private/linearise.m

% [L F] = LINOP(N,U,FLAG) offers direct access to LINEARISE. N is
% linearised around U. If FLAG=1, an error is thrown if N is nonlinear,
% if FLAG=0 this error is ignored and the linearised version of N returned.

% For expm, we need to be able to linearize around u = 0, so we offer the
% option of linearizing around a certain function here (similar to diff),
% the difference is that we check for linearity in this method as well.
if nargin == 1 || (nargin > 1 && isempty(u))
    if isempty(N.dom)
        error('CHEBFUN:chebop:linop:emptydomain', ...
            'Cannot linearise a chebop defined on an empty domain.'); 
    end
%   Create a chebfun to let the operator operate on. Using the findguess
%   method ensures that the guess is of the right (quasimatrix) dimension.
    if ~isa(N.op,'linop')
        u = findguess(N,0);
    else
        u = [];
    end
end

if nargin < 3
    flag = 1;
end

if nargout == 1
    [L bc isLin] = linearise(N,u,flag);
else
    % Compute the affine part.
    [L bc isLin f] = linearise(N,u,flag);
end

if isLin || ~flag
    L = L&bc;
else
    error('CHEBOP:linop:nonlinear','Chebop does not appear to be a linear operator.')
end