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
          if isa(val,'struct')  % given .left and .right
            if isfield(val,'left')
              F = set(F,'lbc',val.left);
             end
            if isfield(val,'right')
              F = set(F,'rbc',val.right);
            end
          else  % given same for both sides
            F = set(F,'lbc',val);
            F = set(F,'rbc',val);
          end
        case 'lbc'
            F.lbc = createbc(val);
            F.lbcshow = val;
        case 'rbc'
            F.rbc = createbc(val);
            F.rbcshow = val;
        case 'op'
            if isa(val,'function_handle') || (iscell(val) && isa(val{1},'function_handle'))
                F.optype = 'anon_fun';
            elseif isa(val,'chebop') || (isa(val,'cell') && isa(val{1},'chebop'))
                F.optype = 'chebop';
            else
                error('chebop:set:opType','Operator must by a function handle or linop.')
            end
            F.op = val;
            if ~iscell(val)
              F.opshow = {char(val)}; 
            else
              F.opshow = cellfun(@char,val,'uniform',false);
            end
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
