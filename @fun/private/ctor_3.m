function g = ctor_3(g,op,n,scl)

% set scale
g.scl = scl;

if ~all(isfield(scl,{'v','h'}))
    error(['Scale argument should be a structure with the fields ''v'''...
        ' and ''h''.']);
end
switch class(op)
    case 'fun'      % returns the same fun
        warning(['Generating fun from fun object on the first' ...
            ' input argument. Other arguments are not used.'])
        g = op;  
        return
    case 'double'   % assigns value to the Chebyshev points
        warning(['Generating fun from fun object on the first' ...
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
            ' cannot be used to construct a fun object'])
end
npower = floor(log2(n));
if 2^npower ~= n
    kk = [2.^(4:npower) n] + 1;
else
    kk = 2.^(4:npower) + 1;
end
for k = kk
    g = set(g,'vals',op(chebpts(k)));
    g = simplify(g);
    if g.n < k, break, end
end