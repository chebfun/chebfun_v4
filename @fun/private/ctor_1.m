function g = ctor_1(g,op)

switch class(op)
    case 'fun'      % returns the same fun
        g = op;  
        return
    case 'double'   % assigns value to the Chebyshev points
        g = set(g,'vals',op(:));
        return
    case 'char'
        if ~isempty(str2num(op))
            error(['A fun cannot be constructed from a string with '...
                ' numerical values.'])
        end
        op = inline(op);
     case 'function_handle'
        % error message if numerical values, e.g op = @(x) 1;
        % op = op;
    otherwise
        error(['The input argument of class ' class(op) ...
            'cannot be used to construct a fun object'])
end
npower = 16;
for k = 2.^(2:npower)+1
    g = set(g,'vals',op(chebpts(k)));
    g = simplify(g);
    if g.n < k, break, end
end