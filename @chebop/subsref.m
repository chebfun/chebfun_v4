function varargout = subsref(f,index)
% SUBSREF   Evaluate a chebop
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

idx = index(1).subs;
switch index(1).type
    case '.'
        varargout = { get(f,idx) };
        if length(index)>1
          fun = @(v) subsref(v,index(2:end));
          varargout = cellfun(fun,varargout,'uniform',false);
        end
    case '()'
        if ~isnumeric(idx{1})
            varargout = {feval(f,idx{1})};
        else
            [L linBC isLin] = linearise(f);
            if ~isLin
                error('CHEBOP:feval:expansion','Matrix expansion is only allowed for linear chebops.')
            end
            L = L & linBC;
            varargout{1} = subsref(L,index);
        end
    otherwise
        error('CHEBOP:subsref:indexType',['Unexpected index.type of ' index(1).type]);
end