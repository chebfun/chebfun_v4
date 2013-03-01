function varargout = ellipsoid(a,b,c)
%ELLIPSOID Generate ELLIPSOID represented by chebfun2 or chebfun2v objects.
%
%  ELLIPSOID(A,B,C), where A, B, and C are chebfun2 objects on the domain 
%  [0 pi]x[0 2*pi] plots the "ELLIPSOID" of semi axis lengths A(th,phi), 
%  B(th,phi), and C(th,phi).
%
%  [X Y Z]=ELLIPSOID(A,B,C) returns X, Y, and Z as chebfun2 objects such that
%  SURF(X,Y,Z) plots an ELLIPSOID of semi axis lengths A(th,phi), 
%  B(th,phi), and C(th,phi).
% 
%  F = ELLIPSOID(A,B,C) returns the chebfun2v representing the ELLIPSOID 
%  SURF(F) plots the ELLIPSOID. 
%
% For the ellipsoid: 
%   a = chebfun2(@(th,phi) 1+0*th,[0 pi 0 2*pi]);
%   ellipsoid(a,2*a,3*a)
%
% For a 'bad' looking ship: 
%   a = chebfun2(@(th,phi) th,[0 pi 0 2*pi])
%   ellipsoid(a,2*a,cos(2*a)+.25)
%
% See also SPHERE, CYLINDER.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if ( nargin < 3 )
    error('CHEBFUN2:ELLIPSOID:INPUTS','Incorrect input arguments.');
end

% ELLIPSOID with axis lengths a(th,phi), b(th,phi), c(th,phi).  
rect = [0 pi 0 2*pi]; 
th = chebfun2(@(th,phi) th,rect);
phi = chebfun2(@(th,phi) phi,rect);

x = a.*sin(th).*cos(phi);
y = b.*sin(th).*sin(phi);
z = c.*cos(th);

if ( nargout == 0 )
    surf(x,y,z); axis equal
elseif ( nargout == 1 )
    varargout = { [x; y; z] };
else
    varargout = { x, y, z };
end
    
end