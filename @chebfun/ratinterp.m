function [p,q,r_handle] = ratinterp(f,m,varargin)
% RATIONAL INTERPOLATION
% [P,Q,R_HANDLE] = RATINTERP(F,M,N) constructs the [M/N]-rational interpolant 
% R = P/Q in M+N+1 Chebyshev points. P is a chebfun of length M+1 and Q is 
% a chebfun of length N+1. R_HANDLE is a function handle that evaluates the
% rational function using the barycentric formula.
%
% [P,Q,R_HANDLE] = RATINTERP(F,M,N,XGRID) constructs the [M/N]-rational
% interpolant R_HANDLE = P/Q on a grid XGRID of length M+N+1 which should
% normally lie in the domain of F.
%
% [P,Q,R_HANDLE] = RATINTERP(F_HANDLE,D,M,N,XGRID) uses a function handle
% F_HANDLE on a domain F to construct the rational interpolant.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: pachon $: $Rev: 768 $:
%  $Date: 2009-11-16 12:54:19 +0000 (Mon, 16 Nov 2009) $:

%  This version of RATINTERP lives in @chebfun.
%  We call @domain/ratinterp to do the work:

d = domain(f);
[p,q,r_handle] = ratinterp(@(x) feval(f,x) ,d,m,varargin{1:end});