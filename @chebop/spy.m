function spy(S,varargin)
% SPY Visualize sparsity pattern.
%  SPY(S) plots the sparsity pattern of the linear chebop S.
%
%  SPY(S,C) uses the color given by C.
%
%  Example:
%   d = domain(-1,.5,1);
%   spy([diff(d) 0 ; 1 diff(d,2)],'m')

S = linop(S);

spy(S,varargin{:})
