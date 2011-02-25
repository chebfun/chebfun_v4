function E = expm(N)
% EXPM  Exponential of a linear chebop.
%
% For repeated use, it might be worth creating a linop explicitly using the
% chebop/linop method.
%
% See also linop/linop

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Linearize and check whether the chebop is linear
try
    L = linop(N,chebfun(0,N.dom));
catch ME
    if strcmp(ME.identifier,'CHEBOP:linop:nonlinear')
        error('CHEBOP:expm',['Chebop appears to be nonlinear. Currently, expm is only' ...
            '\nsupported for linear chebops.']);
    else
        rethrow(ME)
    end
end

E = expm(L);