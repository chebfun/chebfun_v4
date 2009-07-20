function f = ctor_2(f,ops,ends,pref)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if length(ends) ~= length(ops)+1
    error(['Unrecognized input sequence: Number of intervals '...
        'do not agree with number of funs'])
end
if any(diff(ends)<0), 
    error(['Vector of endpoints should have increasing values'])
end
funs = [];
hs = norm(ends([1,end]),inf);
if hs == inf
    hs = 1;
end
scl.v=0; scl.h= hs;
newends = ends(1);

if isa(ops,'chebfun')
    if numel(ops) > 1
        error('chebfun:ctor_2','Only one chebfun is allowed for this call');
    end
    if ops.ends(1) <= ends(1) && ops.ends(end) >= ends(end)
        f = restrict(f,[ends(1) ends(end)]);
    else
        error('chebfun:c_tor2:domain','chebfun is not defined in the domain')
    end
    return
end

for i = 1:length(ops)
    op = ops{i};
    switch class(op)
        case 'double'
            funs = [funs fun(op,ends(i:i+1))];
            newends = [newends ends(i+1)];
        case 'fun'
            if numel(op) > 1
            error(['A vector of funs cannot be used to construct '...
                ' a chebfun.'])
            end
            if norm(op.map.par(1:2)-ends(i:i+1)) > scl.h*1e-15
                error('chebfun:ctor_1:domain','Incosistent doamins')
            else
                funs = [funs op];
                newends = [newends ends(i+1)];
            end
        case 'char'
            if ~isempty(str2num(op))
                error(['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
            op = inline(op);
            vectorcheck(op,ends(i:i+1));
            [fs,es,scl] = auto(op,ends(i:i+1),scl,pref);
            funs = [funs fs];
            newends = [newends es(2:end)];
        case 'function_handle'
            vectorcheck(op,ends(i:i+1));
            [fs,es,scl] = auto(op,ends(i:i+1),scl,pref);
            funs = [funs fs];
            newends = [newends es(2:end)];
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
% switch class(op)
%     case 'double', imps(end+1) = op(end);
%     case 'fun'   , imps(end+1) = op.vals(end);
% end

imps = jumpvals(funs,newends,op); % Update values at jumps, first row of imps.
f = set(f,'funs',funs,'ends',newends,'imps',imps,'trans',0);

if length(f.ends)>2 
    f = merge(f,find(~ismember(newends,ends)),pref); % Avoid merging at specified breakpoints
end