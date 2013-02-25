function varargout = cylinder(r, n, varargin)
%CYLINDER Generate cylinder.
%   [X, Y, Z] = CYLINDER(R, N) forms the unit cylinder based on the sampled
%   generator curve in the chebfun R. The cylinder has N points around the 
%   circumference.
%   [X, Y, Z] = CYLINDER(R) defaults to N = 50. SURF(X,Y,Z) displays the
%   cylinder.
%
%   Omitting output arguments causes the cylinder to be displayed with a SURF
%   command and no outputs to be returned.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Convert r to discrete values:
ends = r.ends;
r = feval(r, linspace(ends(1), ends(end), 101));

% Make the resulution a bit higher:
if ( nargin < 2 )
    n = 50;
end

% Call the discrete cylinder function:
if ( nargout == 0 )
    cylinder(r, n, varargin{:});
else
    [varargout{1}, varargout{2}, varargout{3}] = cylinder(r, n, varargin{:});
end
