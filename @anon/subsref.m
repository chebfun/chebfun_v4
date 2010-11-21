function varargout = subsref(an,index)
% SUBSREF for the anon class. At the moment, the only allowed subsref type
% is . and ().

idx = index(1).subs;
switch index(1).type
    case '.'
        switch(idx)
            case 'function'
                varargout = {an.function};
            case 'variablesName'
                varargout = {an.variablesName};
            case 'workspace'
                varargout = {an.workspace};
            case 'depth'
                varargout = {an.depth};
            otherwise
                error('ANON:get:propnam',[propName,' is not a varargoutid anon property.'])
        end
    case '()'
        varargout = {feval(an,idx{1})};
    otherwise
        error('CHEBFUN:anon:subsref',['??? Unexpected index.type of ' index(1).type]);
end
end