function out = subsref(g,index)

if isempty(g)
    out = {};
    return;
end
switch index(1).type
    case '.'
        switch index(1).subs
            case 'vals'
                out = g.vals;
            case 'n'
                out = g.n;
            case 'scl'
                out = g.scl;
            otherwise
                error(['??? Reference to non-existent field '...
                    index(1).subs '.']);
        end
    case '()'       
        %if length(index(1).subs) > 1 || ... 
        %        (numel(g) > length(index(1).subs))
        %    error('Index exceeds dimensions of fun vector.')
        %end
        out = builtin('subsref',g,index(1));
    otherwise
        error(['??? Unexpected index.type of ' index(1).type])
end
if length(index) > 1
    out = subsref(out,index(2:end));
end