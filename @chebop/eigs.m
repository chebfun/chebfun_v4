function [V D] = eigs(N,varargin)
% EIGS  Find selected eigenvalues and eigenfunctions of a linear chebop.
%
% Example:
% 
% [d,x,N] = domain(0,pi);
% N.op = @(u) diff(u,2);
% N.bc = 'dirichlet';
% [V,D]=eigs(N,10);
% format long, sqrt(-diag(D))  % integers, to 14 digits
%
% See also linop/eigs.

% Linearize and check whether the chebop is linear
try
    L = linop(N);
catch ME
    if strcmp(ME.identifier,'CHEBOP:linop:nonlinear')
        error('CHEBOP:eigs',['Chebop appears to be nonlinear. Currently, eigs is only' ...
            '\nsupported for linear chebops.']);
    else
        rethrow(ME)
    end
end

nargout

if nargout < 2
    D = eigs(L,varargin{:});
    V = D; % Need to switch order of output variables
else
    [V D] = eigs(L,varargin{:});
end

