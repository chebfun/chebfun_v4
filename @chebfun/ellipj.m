function [sn,cn,dn] = ellipj(u,m,tol)
%ELLIPJ Jacobi elliptic functions.
%   [SN,CN,DN] = ELLIPJ(U,M) returns the chebfuns of the Jacobi elliptic 
%   functions Sn, Cn, and Dn with parameter M composed with the chebfun U.
%   As currently implemented, M must be a scalar and is limited to 0 <= M <= 1. 
%
%   [SN,CN,DN] = ELLIPJ(U,M,TOL) computes the elliptic functions to
%   the accuracy TOL instead of the default TOL = CHEBFUNPREF('EPS').  
%
%   Some definitions of the Jacobi elliptic functions use the modulus
%   k instead of the parameter M.  They are related by M = k^2.
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.
%
%   See also ELLIPKE

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~isreal(u),
    error('chebfun:ellipj:imaginaryinput', ...
        'ellipj only accepts real inputs');
end

if nargin < 3
    tol = chebfunpref('eps');
end

% SN
sn = comp(u, @(x) ellipj(x,m,tol));

% CN
if nargout >= 2
    cn = comp(u, @(x) cnfun(x,m,tol));
end

% DN
if nargout == 3
    dn = comp(u, @(x) dnfun(x,m,tol));
end

function cnout = cnfun(u,varargin)
[~, cnout, ~] = ellipj(u,varargin{:});

function dnout = dnfun(u,varargin)
[~, ~, dnout] = ellipj(u,varargin{:});
