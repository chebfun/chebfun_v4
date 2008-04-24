function f = ctor_3(f,ops,ends,n)

if length(ends) ~= length(ops)+1
    error(['Unrecognized input sequence: Number of intervals '...
        'do not agree with number of funs'])
end
if length(n) ~= length(ops)
    error(['Unrecognized input sequence: Number of Chebyshev '...
        'poins was not specified for all the funs.'])
end
if any(diff(ends)<0), 
    error(['Vector of endpoints should have increasing values.'])
end
if any(n-round(n))
    error(['Vector with number of Chebyshev points should consist of'...
        ' integers.'])
end

funs = [];
scl = 0;
for i = 1:length(ops)
    op = ops{i};
    switch class(op)
        case 'double'
            warning(['Generating fun from a numerical vector. '...
                'Associated number of Chebyshev points is not used.']);
            funs = [funs fun(op)];
            scl = max(scl,norm(op,inf));
        case 'fun'
            if numel(op) > 1
            error(['A vector of funs cannot be used to construct '...
                ' a chebfun.'])
            end
            warning(['Generating fun from another. '...
                'Associated number of Chebyshev points is not used.']);
            funs = [funs op];
            scl = max(scl,op.scl.v);
        case 'char'
            if ~isempty(str2num(op))
                error(['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
            a = ends(i); b = ends(i+1);
            op = inline(op);
            op = vectorwrap(op,[a b]);
            g = fun(@(x) op(.5*((b-a)*x+b+a)), n(i));
            funs = [funs g];
            scl = max(scl, norm(g.vals,inf));
        case 'function_handle'
            a = ends(i); b = ends(i+1);   
            op = vectorwrap(op,[a b]);
            g = fun(@(x) op(.5*((b-a)*x+b+a)), n(i));
            funs = [funs g];
            scl = max(scl, norm(g.vals,inf));
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
end

imps = jumpvals(funs,ends,op,zeros(size(ends))); % Update values at jumps, first row of imps.
f = set(f,'funs',funs,'ends',ends,'imps',imps,'trans',0,'scl',scl);