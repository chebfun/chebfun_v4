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
            if strcmp(val,'neumann')
                F.lbc = @(u) diff(u);
                F.rbc = @(u) diff(u);
            elseif strcmp(val,'dirichlet')
                F.lbc = @(u) u;
                F.rbc = @(u) u;
            elseif isnumeric(val)
                F.lbc = @(u) u-val;
                F.rbc = @(u) u-val;
            else
                F.lbc = val;
                F.rbc = val;
            end
        case 'lbc'
            if strcmp(val,'neumann')
                F.lbc = @(u) diff(u);
            elseif strcmp(val,'dirichlet')
                F.lbc = @(u) u;
            elseif isnumeric(val)
                F.lbc = @(u) u-val;
            else
                F.lbc = val;
            end
        case 'rbc'
            if strcmp(val,'neumann')
                F.rbc = @(u) diff(u);
            elseif strcmp(val,'dirichlet')
                F.rbc = @(u) u;
            elseif isnumeric(val)
                F.rbc = @(u) u-val;
            else
                F.rbc = val;
            end
        case 'op'
            if isa(val,'function_handle') || (isa(val,'cell') && isa(val{1},'function_handle'))
                F.optype = 'anon_fun';
            elseif isa(val,'chebop') || (isa(val,'cell') && isa(val{1},'chebop'))
                F.optype = 'chebop';
            else
                error(['nonlinop:set: Illegal type of operator. Allowed types are ' ...
                    'anonymous functions and chebops.']);
            end
            F.op = val;
        case 'guess'
            F.guess = val;
        otherwise
            error('Unknown nonlinop property')
    end
end