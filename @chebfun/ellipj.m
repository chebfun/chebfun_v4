function [sn,cn,dn] = ellipj(u,m,tol)
%ELLIPJ Jacobi elliptic functions.
%   [SN,CN,DN] = ELLIPJ(U,M) returns the chebfuns of the Jacobi elliptic 
%   functions Sn, Cn, and Dn with parameter M composed with the chebfun U.
%   As currently implemented, M must be a scalar and is limited to 0 <= M <= 1. 
%
%   [SN,CN,DN] = ELLIPJ(U,M,TOL) computes the elliptic functions to
%   the accuracy TOL instead of the default TOL = CHEBFUNPREF('EPS').
%
%   Complex values of U are accepted, but the resulting computation may be
%   inaccurate. Use ELLIPJC from Driscoll's SC toolbox instead.
%
%   Some definitions of the Jacobi elliptic functions use the modulus
%   k instead of the parameter M.  They are related by M = k^2.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%   See also ELLIPKE

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if nargin < 3
    tol = chebfunpref('eps');
end

if isreal(u)
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
        
else
    % Use imaginary transformations
    [s c d] = ellipj(real(u),m,tol);        % real values
    [s1 c1 d1] = ellipj(imag(u),1-m,tol);   % imaginary values
    denom = c1.^2+m*(s.*s1).^2;
    % SN
    sn = (s.*d1+1i*c.*d.*s1.*c1)./denom;
    % CN
    if nargout >= 2, cn = (c.*c1-1i*s.*d.*s1.*d1)./denom; end
    % DN
    if nargout == 3, dn = (d.*c1.*d1-1i*m*s.*c.*s1)./denom; end  
    
end

for k = 1:numel(sn)
    switch nargout
        case 3
            sn(k).jacobian = anon('@(u) diag(cn.*dn)*jacobian(F,u)',{'cn' 'dn' 'F'},{cn(k) dn(k) u(k)}); 
            cn(k).jacobian = anon('@(u) diag(-sn.*dn)*jacobian(F,u)',{'sn' 'dn' 'F'},{sn(k) dn(k) u(k)}); 
            dn(k).jacobian = anon('@(u) diag(-m*sn.*cn)*jacobian(F,u)',{'sn' 'cn' 'm' 'F'},{sn(k) cn(k) m u(k)}); 
            sn(k).ID = newIDnum();         cn(k).ID = newIDnum();        dn(k).ID = newIDnum();
    	case 2
            sn(k).jacobian = anon('@(u) diag(cn.*dnfun(F,v{:}))*jacobian(F,u)',{'v' 'F' 'cn'},{{m tol} u(k) cn(k)});
            cn(k).jacobian = anon('@(u) diag(-sn.*dnfun(F,v{:}))*jacobian(F,u)',{'v' 'F' 'sn'},{{m tol} u(k) sn(k)});
            sn(k).ID = newIDnum();         cn(k).ID = newIDnum();
        case 1
            sn(k).jacobian = anon('@(u) diag(cnfun(F,v{:}).*dnfun(F,v{:}))*jacobian(F,u)',{'v' 'F'},{{m tol} u(k)});
            sn(k).ID = newIDnum();
    end
end

function cnout = cnfun(u,varargin)
[ignored, cnout, ignored] = ellipj(u,varargin{:});

function dnout = dnfun(u,varargin)
[ignored, ignored, dnout] = ellipj(u,varargin{:});
