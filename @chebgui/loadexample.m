function cg = loadexample(guifile,exampleNumber,type)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if strcmpi(type,'bvp')
    cg = bvpdemos(guifile,exampleNumber);
elseif strcmpi(type,'pde')
    cg = pdedemos(guifile,exampleNumber);
else
    cg = eigdemos(guifile,exampleNumber);
end
