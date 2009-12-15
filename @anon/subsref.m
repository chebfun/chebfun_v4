function varargout = subsref(f,index)
% SUBSREF for the anon class. At the moment, the only allowed subsref type
% is ().

idx = index(1).subs;
switch index(1).type
    case '()'
        varargout = {feval(f,idx{1})};
    otherwise
        error('CHEBFUN:anon:subsref',['??? Unexpected index.type of ' index(1).type]);
end
end