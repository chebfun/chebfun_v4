function Fout = airy(varargin)
% AIRY   Airy chebfun of a chebfun.
% AIRY(F) returns the Airy function of a chebfun F. 
% AIRY(K,F) uses the parameter K as the standard MATLAB command AIRY to 
% compute different results based on the Airy function
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin == 1,  
    F = varargin{1};
    Fout = comp(F, @(x) real(airy(x)));
else
    K = varargin{1}; F = varargin{2};
    Fout = comp(F, @(x) real(airy(K,x)));
end