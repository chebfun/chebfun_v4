function map = maps(varargin)
% MAPS
%  M = MAPS(D) returns the default Chebfun map for the domain D.

% This code is just a wrapper for fun/maps.

map = maps(fun,varargin{:});

