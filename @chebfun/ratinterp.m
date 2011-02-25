function [p,q,rh] = ratinterp(f,varargin)
% RATIONAL INTERPOLATION
% [P,Q,R_HANDLE] = RATINTERP(F,M,N) constructs the [M/N]-rational interpolant 
% R = P/Q of a chebfun F in M+N+1 Chebyshev points. P is a chebfun of length 
% M+1 and Q is a chebfun of length N+1. R_HANDLE is a function handle that 
% evaluates the rational function using the barycentric formula. (A function 
% handle is used because constructing a chebfun for a quotient P./Q may be very
% inefficient).
%
% [P,Q,R_HANDLE] = RATINTERP(F,M,N,XGRID) constructs the [M/N]-rational
% interpolant R_HANDLE = P/Q on a grid XGRID of length M+N+1 which should
% lie in the domain of F.
%
% RATINTERP(F,M,N,'chebpts',KIND) specifies a grid of Chebyshev points
% of the first kind if KIND = 1 and second kind if KIND = 2. If not
% specified, the kind of Chebyshev points is taken from
% CHEBFUNPREF('CHEBKIND').
%
% RATINTERP(F_HANDLE,D,M,N), RATINTERP(F_HANDLE,D,M,N,XGRID) and
% RATINTERP(F_HANDLE,D,M,N,'chebpts',KIND) use a function handle
% F_HANDLE on a domain D to construct the rational interpolant.
%
% RATINTERP uses the algorithm introduced in Pachón R., Gonnet P., van Deun J., 
% "Fast and stable rational interpolation in roots of unity and Chebyshev 
% points", submitted. The case of rational interpolation in roots of unity
% and arbitrary grids on the complex plane are also treated in that paper
% although not implemented in RATINTERP. See also CHEBPADE and CF for other
% rational approximation methods in Chebfun.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

%  This version of RATINTERP lives in @chebfun.
%  We call @domain/ratinterp to do the work:


d = domain(f);
[p,q,rh] = ratinterp(@(x) feval(f,x),d,varargin{1:end});
