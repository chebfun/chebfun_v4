function N = set(N,varargin)
% SET Set chebop properties.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
        case 'dom'
            N.dom = val;
        case 'bc'
            if isa(val,'struct')  % given .left and .right
                if isfield(val,'left')
                    N = set(N,'lbc',val.left);
                end
                if isfield(val,'right')
                    N = set(N,'rbc',val.right);
                end
            else  % given same for both sides
                N = set(N,'lbc',val);
                N = set(N,'rbc',val);
            end
        case 'lbc'
            N.lbc = createbc(val);
            N.lbcshow = val;
        case 'rbc'
            N.rbc = createbc(val);
            N.rbcshow = val;
        case 'op'
            if isa(val,'function_handle') || (iscell(val) && isa(val{1},'function_handle'))
                N.optype = 'anon_fun';
            elseif isa(val,'chebop') || (isa(val,'cell') && isa(val{1},'chebop'))
                N.optype = 'chebop';
            else
                error('CHEBOP:set:opType','Operator must by a function handle or linop.')
            end
            N.op = val;
            if ~iscell(val)
                N.opshow = {char(val)};
            else
                N.opshow = cellfun(@char,val,'uniform',false);
            end
        case 'guess'
            % Convert constant initial guesses to chebfuns
            if isnumeric(val)
                N.guess = chebfun(val,N.dom);
            else
                N.guess = val;
            end
        case 'dim'
            % Sets the dimension of the quasimatrices N operates on
            N.dim = val;
        otherwise
            error('CHEBOP:set:unknownprop','Unknown chebop property')
    end
end
end
