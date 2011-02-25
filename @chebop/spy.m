function spy(S,varargin)
% SPY Visualize sparsity pattern.
%  SPY(S) plots the sparsity pattern of the linear chebop S.
%
%  SPY(S,C) uses the color given by C.
%
%  Example:
%   d = domain(-1,.5,1);
%   spy([diff(d) 0 ; 1 diff(d,2)],'m')

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

S = linop(S);

spy(S,varargin{:})
