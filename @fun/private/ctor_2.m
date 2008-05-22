function g = ctor_2(g,op,n)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

switch class(op)
    case 'fun'      % returns the same fun
        warning(['Generating fun from fun object on the first' ...
            ' input argument. Other arguments are not used.'])
        g = op;  
        return
    case 'double'   % assigns value to the Chebyshev points
        warning(['Generating fun from values on the first' ...
            ' input argument. Other arguments are not used.'])
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
        %op = op;
    otherwise
        error(['The input argument of class ' class(op) ...
            'cannot be used to construct a fun object'])
end
g = set(g,'vals',op(chebpts(n)));