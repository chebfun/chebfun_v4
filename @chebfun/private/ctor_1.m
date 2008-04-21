function f = ctor_1(f,op)


dom = chebfunpref('domain');
switch class(op)
    case 'chebfun'
        f = op;  
        return
    case 'double'
        f = set(f,'funs',fun(op),'ends',dom,...
            'imps',[op(1) op(end)],'trans',0);
        return
    case 'fun'
        if numel(op) > 1
            error(['A vector of funs cannot be used to construct'...
                ' a chebfun.'])
        end
        f = set(f,'funs',op,'ends',dom,...
            'imps',[op.vals(1) op.vals(end)],'trans',0);
    case 'char'
        if ~isempty(str2num(op))
            error(['A chebfun cannot be constructed from a string with'...
                ' numerical values.'])
        end
        op = inline(op);
        [funs,ends] = auto(op,dom);
        f = set(f,'funs',funs,'ends',ends,'trans',0,...
            'imps',op(ends));
    case 'function_handle'
        [funs,ends] = auto(op,dom);
        f = set(f,'funs',funs,'ends',ends,'trans',0,...
            'imps',op(ends)); 
    case 'cell'
        error(['A vector of endpoints is required if a cell '...
            'array is used to specify the desired funs.'])
    otherwise
        error(['The input argument of class ''' class(op) ...
            ''' cannot be used to construct a chebfun.'])
end