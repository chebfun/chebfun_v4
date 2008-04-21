function f = ctor_2(f,ops,ends)

if length(ends) ~= length(ops)+1
    error(['Unrecognized input sequence: Number of intervals '...
        'do not agree with number of funs'])
end
if any(diff(ends)<0), 
    error(['Vector of endpoints should have increasing values'])
end
funs = [];
imps = [];
sing = true;
scl.v=0; scl.h=max(abs(ends(1,end)));
newends = ends(1);
for i = 1:length(ops)
    op = ops{i};
    switch class(op)
        case 'double'
            funs = [funs fun(op)];
            imps(end+1) = op(1);
            newends = [newends ends(i+1)];
        case 'fun'
            if numel(op) > 1
            error(['A vector of funs cannot be used to construct '...
                ' a chebfun.'])
            end
            funs = [funs op];
            imps(end+1) = op.vals(1);
            newends = [newends ends(i+1)];
        case 'char'
            if ~isempty(str2num(op))
                error(['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
            op = inline(op);
            [fs,es,scl,si] = auto(op,ends(i:i+1),scl);
            funs = [funs fs];
            newends = [newends es(2:end)];
            imps = [imps op(es(1:end-1))];
            sing = [sing(1:end-1) si sing(2:end)];
        case 'function_handle'
            [fs,es,scl,si] = auto(op,ends(i:i+1),scl);
            funs = [funs fs];
            newends = [newends es(2:end)];
            imps = [imps op(es(1:end-1))];
            sing = [sing(1:end-1) si sing(2:end)];
        case 'cell'
            error(['Unrecognized input sequence: Attempted to use '...
                'more than one cell array to define the chebfun.'])
        case 'chebfun'
            error(['Unrecognized input sequence: Attempted to construct '...
                'a chebfun from another in an inappropriate way.'])
        otherwise
            error(['The input argument of class ' class(op) ...
                'cannot be used to construct a chebfun object.'])
    end
end
switch class(op)
    case 'double', imps(end+1) = op(end);
    case 'fun'   , imps(end+1) = op.vals(end);
    case {'inline','function_handle'}, imps(end+1) = op(es(end));
end
f = set(f,'funs',funs,'ends',newends,'imps',imps,'trans',0);

% merging step
if length(sing)>2 
    f = merge(f, find(~sing));
end