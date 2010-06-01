function out = int(varargin)
%INT Definite integral of chebfun
% This is simply a dummy routine providining an alternative (more
% intuitive) interface to chebfun/sum.
%
% See also chebfun/sum

out = sum(varargin{:});
