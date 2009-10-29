function Fout = besselj(nu,F)
% BESSELJ   Bessel function of first kind of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) besselj(nu,x));
