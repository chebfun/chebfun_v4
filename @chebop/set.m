function F = set(F,varargin)
% SET Set chebop properties.
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
            F.lbc = createbc(val);
            F.rbc = F.lbc;
        case 'lbc'
            F.lbc = createbc(val);
        case 'rbc'
            F.rbc = createbc(val);
        case 'op'
            if isa(val,'function_handle') || (isa(val,'cell') && isa(val{1},'function_handle'))
                F.optype = 'anon_fun';
            elseif isa(val,'chebop') || (isa(val,'cell') && isa(val{1},'chebop'))
                F.optype = 'chebop';
            else
                error('chebop:set:opType','Operator must by a function handle or linop.')
            end
            F.op = val;
        case 'guess'
            % Convert constant initial guesses to chebfuns
            if isnumeric(val)
                F.guess = chebfun(val,F.dom);
            else
                F.guess = val;
            end
        otherwise
            error('Unknown chebop property')
    end
end
end
