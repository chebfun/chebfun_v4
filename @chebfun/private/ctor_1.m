function f = ctor_1(f,op)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

dom = chebfunpref('domain');
switch class(op)
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
        vectorcheck(op,dom);
        [funs,ends] = auto(op,dom);
        imps = jumpvals(funs,ends,op);
        f = set(f,'funs',funs,'ends',ends,'trans',0,...
            'imps',imps);
    case 'function_handle'
        vectorcheck(op,dom);
        [funs,ends] = auto(op,dom);
        imps = jumpvals(funs,ends,op);
        f = set(f,'funs',funs,'ends',ends,'trans',0,...
            'imps',imps); 
    case 'chebfun'
        if op.ends(1) <= dom(1) && op.ends(end) >= dom(end)
            f = restrict(op,dom);
        else
            error('chebfun:c_tor1:domain','chebfun is not defined in the domain')
        end
            
    case 'cell'
        error(['A vector of endpoints is required if a cell '...
            'array is used to specify the desired funs.'])
    otherwise
        error(['The input argument of class ''' class(op) ...
            ''' cannot be used to construct a chebfun.'])
end

% merging step
if length(f.ends)>2 
    f = merge(f);
end