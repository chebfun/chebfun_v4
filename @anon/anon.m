function ADH = anon(varargin)
% ANON Anon object constructor.
%
% A = anon('function','variables name', variables) creates an anon object
% which behaves in a similar way to anonymous functions.
%
% Example:
%   [d,x] = domain(0,1)
%   A  = anon('@(u) u*sin(x)','x',x)
% creates the anon A which behaves in a similar way to the anonymous
% function F created by
%   F  = @(u) u*sin(x)
%
% The anon class is a support class for working with automatic
% differentiation in the chebfun system and is therefore lightly
% documented. It is intented to be used in the overloaded functions in the
% @chebfun directory.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 


ADH = struct([]);

ADH(1).function = varargin{1};
ADH(1).variablesName = varargin{2};
ADH(1).workspace = varargin{3};

ADH = class(ADH,'anon');
end