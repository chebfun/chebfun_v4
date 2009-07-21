function f = ctor_3(f,ops,ends,n)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

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

% Initial horizontal scale.
hs = norm(ends([1,end]),inf);
if hs == inf
    hs = max(abs(ends(isfinite(ends))+1));
end
scl.v=0; scl.h= hs;

for i = 1:length(ops)
    op = ops{i};
    switch class(op)
        case 'function_handle'
            a = ends(i); b = ends(i+1);
            vectorcheck(op,[a b]);
            g = fun(op, [a b], n(i));
            funs = [funs g];
        case 'char'
            if ~isempty(str2num(op))
                error(['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
            a = ends(i); b = ends(i+1);
            op = inline(op);
            vectorcheck(op,[a b]);
            g = fun(op, [a b], n(i));
            funs = [funs g];
        case 'chebfun'
            a = ends(i); b = ends(i+1);
            if op.ends(1) > a || op.ends(end) < b
                error('chebfun:c_tor3:domain','chebfun is not defined in the domain')
            end
            g = fun(@(x) feval(op,x), [a b], n(i));
            funs = [funs g];
        case 'double'
            error(['Generating fun from a numerical vector. '...
                'Associated number of Chebyshev points is not used.']);
        case 'fun'
            if numel(op) > 1
                error(['A vector of funs cannot be used to construct '...
                    ' a chebfun.'])
            end
            error(['Generating fun from another. '...
                'Associated number of Chebyshev points is not used.']);
        case 'cell'
            error(['Unrecognized input sequence: Attempted to use '...
                'more than one cell array to define the chebfun.'])
        otherwise
            error(['The input argument of class ' class(op) ...
                'cannot be used to construct a chebfun object.'])
    end
    scl.v = max(scl.v, g.scl.v);
    scl.h = max(scl.h, g.scl.h);
end

% First row of imps contains function values
imps = jumpvals(funs,ends,op); 

% update scale field in funs
f.nfuns = length(ends)-1; 
for k = 1:f.nfuns
    funs(k).scl = scl;   
end

% Assign fields to chebfuns.
f.funs = funs; f.ends = ends; f.imps = imps; f.trans = false; f.scl = scl.v;
