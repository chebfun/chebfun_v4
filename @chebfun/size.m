function varargout = size(F,dim)
% SIZE   Size of a chebfun quasimatrix.
%   D = SIZE(F) returns a two-element row vector D = [M,N]. If F is a column
%   quasimatrix, M is infinity and N is the number of columns. For a
%   row quasimatrix, M is the number of rows and N is infinity.
%
%   [M,N] = SIZE(F)  returns the dimensions of F as separate output
%   variables.
%
%  M = SIZE(F,DIM) returns the dimension specified by the scalar DIM.
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if F(1).trans
    m = numel(F);
    n = inf;
else
    m = inf;
    n = numel(F);
end

if nargin == 1 
    if nargout == 2
        varargout = {m ,n};
    else
        varargout = {[m ,n]};
    end
elseif dim==1
    varargout = {m};
else
    varargout = {n};
end
