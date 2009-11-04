function varargout = subsref(f,index)

idx = index(1).subs;
switch index(1).type
    case '()'
        varargout = {feval(f,idx{1})};
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end
end