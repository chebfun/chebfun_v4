function E = expm(N)
% EXPM  Exponential of a linear chebop.
%
% For repeated use, it might be worth creating a linop explicitly using the
% chebop/linop method.
%
% See also linop/linop

% Linearize and check whether the chebop is linear
try
    L = linop(N,chebfun(0,N.dom));
catch ME
    if strcmp(ME.identifier,'CHEBOP:linop:nonlinear')
        error('CHEBOP:expm',['Chebop appears to be nonlinear. Currently, expm is only' ...
            '\nsupported for linear chebops.']);
    end
end

E = expm(L);