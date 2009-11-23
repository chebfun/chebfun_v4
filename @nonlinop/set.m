function F = set(F,varargin)
% SET Set nonlinop properties.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
        case 'dom'
            F.dom = val;
        case 'bc'
            if isequal(val,'neumann')
                    F.lbc = @(u) diff(u);
                    F.rbc = @(u) diff(u);
            elseif isequal(val,'dirichlet')
                    F.lbc = @(u) u;
                    F.rbc = @(u) u;
            else
                    F.lbc = val;
                    F.rbc = val;
            end
        case 'lbc'
            if isequal(val,'neumann')
                    F.lbc = @(u) diff(u);
            elseif isequal(val,'dirichlet')
                    F.lbc = @(u) u;
            else
                    F.lbc = val;
            end
        case 'rbc'
            if isequal(val,'neumann')
                    F.rbc = @(u) diff(u);
            elseif isequal(val,'dirichlet')
                    F.rbc = @(u) u;
            else
                    F.rbc = val;
            end
        case 'op'
            F.op = val;
        case 'guess'
            F.guess = val;
        otherwise
            error('Unknown nonlinop property')
    end
end